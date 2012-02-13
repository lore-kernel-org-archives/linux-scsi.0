From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 08/11] qla4xxx: added support for host event
Date: Mon, 13 Feb 2012 06:07:23 -0800
Message-ID: <CB5F15FF.CA31%vikas.chaudhary@qlogic.com>
References: <1329138050-1042-9-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_CB5F15FFCA31vikaschaudharyqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:28721
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751178Ab2BMOHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 09:07:35 -0500
In-Reply-To: <1329138050-1042-9-git-send-email-vikas.chaudhary@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

--_002_CB5F15FFCA31vikaschaudharyqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

James,

Looks like this email is not going to scsi-list from my Linux box, may be
some configuration issue at my end.
Sending this emil from Microsoft outlook please consider attachment for
this time.

Thanks,
Vikas.

-----Original Message-----
From: Admin <vikas.chaudhary@qlogic.com>
Date: Mon, 13 Feb 2012 05:00:47 -0800
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, Mike Christie
<michaelc@cs.wisc.edu>
Cc: scsi <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>,
Lalit Chandivade <lalit.chandivade@qlogic.com>, Admin
<vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/11] qla4xxx: added support for host event

>From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>
>Added support to post kernel host event to application using
>netlink interface.
>
>Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>---
> drivers/scsi/qla4xxx/ql4_def.h  |   18 ++++++++
> drivers/scsi/qla4xxx/ql4_glbl.h |    2 +
> drivers/scsi/qla4xxx/ql4_isr.c  |    6 +++
> drivers/scsi/qla4xxx/ql4_os.c   |   85
>+++++++++++++++++++++++++++++++++++++++
> 4 files changed, 111 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_def.h
>b/drivers/scsi/qla4xxx/ql4_def.h
>index ec48dc3..f91808c 100644
>--- a/drivers/scsi/qla4xxx/ql4_def.h
>+++ b/drivers/scsi/qla4xxx/ql4_def.h
>@@ -301,7 +301,21 @@ struct ql4_tuple_ddb {
> #define DF_ISNS_DISCOVERED    2       /* Device was discovered via iSNS *=
/
> #define DF_FO_MASKED          3
>
>+enum qla4_work_type {
>+      QLA4_EVENT_AEN,
>+};
>
>+struct qla4_work_evt {
>+      struct list_head list;
>+      enum qla4_work_type type;
>+      union {
>+              struct {
>+                      enum iscsi_host_event_code code;
>+                      uint32_t data_size;
>+                      uint8_t data[0];
>+              } aen;
>+      } u;
>+};
>
> struct ql82xx_hw_data {
>       /* Offsets for flash/nvram access (set to ~0 if not used). */
>@@ -672,6 +686,10 @@ struct scsi_qla_host {
>       uint16_t sec_ddb_idx;
>       int is_reset;
>       uint16_t temperature;
>+
>+      /* event work list */
>+      struct list_head work_list;
>+      spinlock_t work_lock;
> };
>
> struct ql4_task_data {
>diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h
>b/drivers/scsi/qla4xxx/ql4_glbl.h
>index d0dd4b3..34cf851 100644
>--- a/drivers/scsi/qla4xxx/ql4_glbl.h
>+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
>@@ -181,6 +181,8 @@ int qla4xxx_flash_ddb_change(struct scsi_qla_host
>*ha, uint32_t fw_ddb_index,
> int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>                      struct ddb_entry *ddb_entry, uint32_t state);
> void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset);
>+int qla4xxx_post_aen_work(struct scsi_qla_host *ha, uint32_t aen_code,
>+                        uint32_t data_size, uint8_t *data);
>
> /* BSG Functions */
> int qla4xxx_bsg_request(struct bsg_job *bsg_job);
>diff --git a/drivers/scsi/qla4xxx/ql4_isr.c
>b/drivers/scsi/qla4xxx/ql4_isr.c
>index 9582886..954fe84 100644
>--- a/drivers/scsi/qla4xxx/ql4_isr.c
>+++ b/drivers/scsi/qla4xxx/ql4_isr.c
>@@ -576,6 +576,9 @@ static void qla4xxx_isr_decode_mailbox(struct
>scsi_qla_host * ha,
>                               set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
>
>                       ql4_printk(KERN_INFO, ha, "%s: LINK UP\n", __func__=
);
>+                      qla4xxx_post_aen_work(ha, ISCSI_EVENT_LINKUP,
>+                                            sizeof(mbox_sts),
>+                                            (uint8_t *) mbox_sts);
>                       break;
>
>               case MBOX_ASTS_LINK_DOWN:
>@@ -584,6 +587,9 @@ static void qla4xxx_isr_decode_mailbox(struct
>scsi_qla_host * ha,
>                               set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
>
>                       ql4_printk(KERN_INFO, ha, "%s: LINK DOWN\n", __func=
__);
>+                      qla4xxx_post_aen_work(ha, ISCSI_EVENT_LINKDOWN,
>+                                            sizeof(mbox_sts),
>+                                            (uint8_t *) mbox_sts);
>                       break;
>
>               case MBOX_ASTS_HEARTBEAT:
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 2cd2077..d423f7a 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -2282,6 +2282,10 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
>               }
>       }
>
>+      /* Process any deferred work. */
>+      if (!list_empty(&ha->work_list))
>+              start_dpc++;
>+
>       /* Wakeup the dpc routine for this adapter, if needed. */
>       if (start_dpc ||
>            test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
>@@ -2847,6 +2851,81 @@ void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
>               queue_work(ha->dpc_thread, &ha->dpc_work);
> }
>
>+static struct qla4_work_evt *
>+qla4xxx_alloc_work(struct scsi_qla_host *ha, uint32_t data_size,
>+                 enum qla4_work_type type)
>+{
>+      struct qla4_work_evt *e;
>+      uint32_t size =3D sizeof(struct qla4_work_evt) + data_size;
>+
>+      e =3D kzalloc(size, GFP_ATOMIC);
>+      if (!e)
>+              return NULL;
>+
>+      INIT_LIST_HEAD(&e->list);
>+      e->type =3D type;
>+      return e;
>+}
>+
>+static void qla4xxx_post_work(struct scsi_qla_host *ha,
>+                           struct qla4_work_evt *e)
>+{
>+      unsigned long flags;
>+
>+      spin_lock_irqsave(&ha->work_lock, flags);
>+      list_add_tail(&e->list, &ha->work_list);
>+      spin_unlock_irqrestore(&ha->work_lock, flags);
>+      qla4xxx_wake_dpc(ha);
>+}
>+
>+int qla4xxx_post_aen_work(struct scsi_qla_host *ha,
>+                        enum iscsi_host_event_code aen_code,
>+                        uint32_t data_size, uint8_t *data)
>+{
>+      struct qla4_work_evt *e;
>+
>+      e =3D qla4xxx_alloc_work(ha, data_size, QLA4_EVENT_AEN);
>+      if (!e)
>+              return QLA_ERROR;
>+
>+      e->u.aen.code =3D aen_code;
>+      e->u.aen.data_size =3D data_size;
>+      memcpy(e->u.aen.data, data, data_size);
>+
>+      qla4xxx_post_work(ha, e);
>+
>+      return QLA_SUCCESS;
>+}
>+
>+void qla4xxx_do_work(struct scsi_qla_host *ha)
>+{
>+      struct qla4_work_evt *e, *tmp;
>+      unsigned long flags;
>+      LIST_HEAD(work);
>+
>+      spin_lock_irqsave(&ha->work_lock, flags);
>+      list_splice_init(&ha->work_list, &work);
>+      spin_unlock_irqrestore(&ha->work_lock, flags);
>+
>+      list_for_each_entry_safe(e, tmp, &work, list) {
>+              list_del_init(&e->list);
>+
>+              switch (e->type) {
>+              case QLA4_EVENT_AEN:
>+                      iscsi_post_host_event(ha->host_no,
>+                                            &qla4xxx_iscsi_transport,
>+                                            e->u.aen.code,
>+                                            e->u.aen.data_size,
>+                                            e->u.aen.data);
>+                      break;
>+              default:
>+                      ql4_printk(KERN_WARNING, ha, "event type: 0x%x not =
"
>+                                 "supported", e->type);
>+              }
>+              kfree(e);
>+      }
>+}
>+
> /**
>  * qla4xxx_do_dpc - dpc routine
>  * @data: in our case pointer to adapter structure
>@@ -2878,6 +2957,9 @@ static void qla4xxx_do_dpc(struct work_struct *work)
>               return;
>       }
>
>+      /* post events to application */
>+      qla4xxx_do_work(ha);
>+
>       if (is_qla8022(ha)) {
>               if (test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags)) {
>                       qla4_8xxx_idc_lock(ha);
>@@ -4450,6 +4532,9 @@ static int __devinit qla4xxx_probe_adapter(struct
>pci_dev *pdev,
>
>       spin_lock_init(&ha->hardware_lock);
>
>+      /* Initialize work list */
>+      INIT_LIST_HEAD(&ha->work_list);
>+
>       /* Allocate dma buffers */
>       if (qla4xxx_mem_alloc(ha)) {
>               ql4_printk(KERN_WARNING, ha,
>--
>1.7.8.247.g10f4e
>


This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_002_CB5F15FFCA31vikaschaudharyqlogiccom_
Content-Type: application/octet-stream;
	name="0008-qla4xxx-added-support-for-host-event.patch"
Content-Description: 0008-qla4xxx-added-support-for-host-event.patch
Content-Disposition: attachment;
	filename="0008-qla4xxx-added-support-for-host-event.patch"; size=6074;
	creation-date="Mon, 13 Feb 2012 14:07:26 GMT";
	modification-date="Mon, 13 Feb 2012 14:07:26 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzOTdlNjZiMjNmNWM1NDZjNzgyYmVlNGZkOTRmZjY1YWFkNDcyZWFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaWthcyBDaGF1ZGhhcnkgPHZpa2FzLmNoYXVkaGFyeUBxbG9n
aWMuY29tPgpEYXRlOiBNb24sIDI5IEF1ZyAyMDExIDIzOjQzOjAyICswNTMwClN1YmplY3Q6IFtQ
QVRDSCAwOC8xMV0gcWxhNHh4eDogYWRkZWQgc3VwcG9ydCBmb3IgaG9zdCBldmVudAoKQWRkZWQg
c3VwcG9ydCB0byBwb3N0IGtlcm5lbCBob3N0IGV2ZW50IHRvIGFwcGxpY2F0aW9uIHVzaW5nCm5l
dGxpbmsgaW50ZXJmYWNlLgoKU2lnbmVkLW9mZi1ieTogVmlrYXMgQ2hhdWRoYXJ5IDx2aWthcy5j
aGF1ZGhhcnlAcWxvZ2ljLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvcWxhNHh4eC9xbDRfZGVmLmgg
IHwgICAxOCArKysrKysrKwogZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X2dsYmwuaCB8ICAgIDIg
KwogZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X2lzci5jICB8ICAgIDYgKysrCiBkcml2ZXJzL3Nj
c2kvcWxhNHh4eC9xbDRfb3MuYyAgIHwgICA4NSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysKIDQgZmlsZXMgY2hhbmdlZCwgMTExIGluc2VydGlvbnMoKyksIDAgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X2RlZi5oIGIvZHJp
dmVycy9zY3NpL3FsYTR4eHgvcWw0X2RlZi5oCmluZGV4IGVjNDhkYzMuLmY5MTgwOGMgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGE0eHh4L3FsNF9kZWYuaAorKysgYi9kcml2ZXJzL3Njc2kv
cWxhNHh4eC9xbDRfZGVmLmgKQEAgLTMwMSw3ICszMDEsMjEgQEAgc3RydWN0IHFsNF90dXBsZV9k
ZGIgewogI2RlZmluZSBERl9JU05TX0RJU0NPVkVSRUQJMgkvKiBEZXZpY2Ugd2FzIGRpc2NvdmVy
ZWQgdmlhIGlTTlMgKi8KICNkZWZpbmUgREZfRk9fTUFTS0VECQkzCiAKK2VudW0gcWxhNF93b3Jr
X3R5cGUgeworCVFMQTRfRVZFTlRfQUVOLAorfTsKIAorc3RydWN0IHFsYTRfd29ya19ldnQgewor
CXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKKwllbnVtIHFsYTRfd29ya190eXBlIHR5cGU7CisJdW5p
b24geworCQlzdHJ1Y3QgeworCQkJZW51bSBpc2NzaV9ob3N0X2V2ZW50X2NvZGUgY29kZTsKKwkJ
CXVpbnQzMl90IGRhdGFfc2l6ZTsKKwkJCXVpbnQ4X3QgZGF0YVswXTsKKwkJfSBhZW47CisJfSB1
OworfTsKIAogc3RydWN0IHFsODJ4eF9od19kYXRhIHsKIAkvKiBPZmZzZXRzIGZvciBmbGFzaC9u
dnJhbSBhY2Nlc3MgKHNldCB0byB+MCBpZiBub3QgdXNlZCkuICovCkBAIC02NzIsNiArNjg2LDEw
IEBAIHN0cnVjdCBzY3NpX3FsYV9ob3N0IHsKIAl1aW50MTZfdCBzZWNfZGRiX2lkeDsKIAlpbnQg
aXNfcmVzZXQ7CiAJdWludDE2X3QgdGVtcGVyYXR1cmU7CisKKwkvKiBldmVudCB3b3JrIGxpc3Qg
Ki8KKwlzdHJ1Y3QgbGlzdF9oZWFkIHdvcmtfbGlzdDsKKwlzcGlubG9ja190IHdvcmtfbG9jazsK
IH07CiAKIHN0cnVjdCBxbDRfdGFza19kYXRhIHsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9x
bGE0eHh4L3FsNF9nbGJsLmggYi9kcml2ZXJzL3Njc2kvcWxhNHh4eC9xbDRfZ2xibC5oCmluZGV4
IGQwZGQ0YjMuLjM0Y2Y4NTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9xbGE0eHh4L3FsNF9n
bGJsLmgKKysrIGIvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X2dsYmwuaApAQCAtMTgxLDYgKzE4
MSw4IEBAIGludCBxbGE0eHh4X2ZsYXNoX2RkYl9jaGFuZ2Uoc3RydWN0IHNjc2lfcWxhX2hvc3Qg
KmhhLCB1aW50MzJfdCBmd19kZGJfaW5kZXgsCiBpbnQgcWxhNHh4eF9kZGJfY2hhbmdlKHN0cnVj
dCBzY3NpX3FsYV9ob3N0ICpoYSwgdWludDMyX3QgZndfZGRiX2luZGV4LAogCQkgICAgICAgc3Ry
dWN0IGRkYl9lbnRyeSAqZGRiX2VudHJ5LCB1aW50MzJfdCBzdGF0ZSk7CiB2b2lkIHFsYTR4eHhf
YnVpbGRfZGRiX2xpc3Qoc3RydWN0IHNjc2lfcWxhX2hvc3QgKmhhLCBpbnQgaXNfcmVzZXQpOwor
aW50IHFsYTR4eHhfcG9zdF9hZW5fd29yayhzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqaGEsIHVpbnQz
Ml90IGFlbl9jb2RlLAorCQkJICB1aW50MzJfdCBkYXRhX3NpemUsIHVpbnQ4X3QgKmRhdGEpOwog
CiAvKiBCU0cgRnVuY3Rpb25zICovCiBpbnQgcWxhNHh4eF9ic2dfcmVxdWVzdChzdHJ1Y3QgYnNn
X2pvYiAqYnNnX2pvYik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhNHh4eC9xbDRfaXNy
LmMgYi9kcml2ZXJzL3Njc2kvcWxhNHh4eC9xbDRfaXNyLmMKaW5kZXggOTU4Mjg4Ni4uOTU0ZmU4
NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X2lzci5jCisrKyBiL2RyaXZl
cnMvc2NzaS9xbGE0eHh4L3FsNF9pc3IuYwpAQCAtNTc2LDYgKzU3Niw5IEBAIHN0YXRpYyB2b2lk
IHFsYTR4eHhfaXNyX2RlY29kZV9tYWlsYm94KHN0cnVjdCBzY3NpX3FsYV9ob3N0ICogaGEsCiAJ
CQkJc2V0X2JpdChEUENfTElOS19DSEFOR0VELCAmaGEtPmRwY19mbGFncyk7CiAKIAkJCXFsNF9w
cmludGsoS0VSTl9JTkZPLCBoYSwgIiVzOiBMSU5LIFVQXG4iLCBfX2Z1bmNfXyk7CisJCQlxbGE0
eHh4X3Bvc3RfYWVuX3dvcmsoaGEsIElTQ1NJX0VWRU5UX0xJTktVUCwKKwkJCQkJICAgICAgc2l6
ZW9mKG1ib3hfc3RzKSwKKwkJCQkJICAgICAgKHVpbnQ4X3QgKikgbWJveF9zdHMpOwogCQkJYnJl
YWs7CiAKIAkJY2FzZSBNQk9YX0FTVFNfTElOS19ET1dOOgpAQCAtNTg0LDYgKzU4Nyw5IEBAIHN0
YXRpYyB2b2lkIHFsYTR4eHhfaXNyX2RlY29kZV9tYWlsYm94KHN0cnVjdCBzY3NpX3FsYV9ob3N0
ICogaGEsCiAJCQkJc2V0X2JpdChEUENfTElOS19DSEFOR0VELCAmaGEtPmRwY19mbGFncyk7CiAK
IAkJCXFsNF9wcmludGsoS0VSTl9JTkZPLCBoYSwgIiVzOiBMSU5LIERPV05cbiIsIF9fZnVuY19f
KTsKKwkJCXFsYTR4eHhfcG9zdF9hZW5fd29yayhoYSwgSVNDU0lfRVZFTlRfTElOS0RPV04sCisJ
CQkJCSAgICAgIHNpemVvZihtYm94X3N0cyksCisJCQkJCSAgICAgICh1aW50OF90ICopIG1ib3hf
c3RzKTsKIAkJCWJyZWFrOwogCiAJCWNhc2UgTUJPWF9BU1RTX0hFQVJUQkVBVDoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9xbGE0eHh4L3FsNF9vcy5jIGIvZHJpdmVycy9zY3NpL3FsYTR4eHgv
cWw0X29zLmMKaW5kZXggMmNkMjA3Ny4uZDQyM2Y3YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3Np
L3FsYTR4eHgvcWw0X29zLmMKKysrIGIvZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X29zLmMKQEAg
LTIyODIsNiArMjI4MiwxMCBAQCBzdGF0aWMgdm9pZCBxbGE0eHh4X3RpbWVyKHN0cnVjdCBzY3Np
X3FsYV9ob3N0ICpoYSkKIAkJfQogCX0KIAorCS8qIFByb2Nlc3MgYW55IGRlZmVycmVkIHdvcmsu
ICovCisJaWYgKCFsaXN0X2VtcHR5KCZoYS0+d29ya19saXN0KSkKKwkJc3RhcnRfZHBjKys7CisK
IAkvKiBXYWtldXAgdGhlIGRwYyByb3V0aW5lIGZvciB0aGlzIGFkYXB0ZXIsIGlmIG5lZWRlZC4g
Ki8KIAlpZiAoc3RhcnRfZHBjIHx8CiAJICAgICB0ZXN0X2JpdChEUENfUkVTRVRfSEEsICZoYS0+
ZHBjX2ZsYWdzKSB8fApAQCAtMjg0Nyw2ICsyODUxLDgxIEBAIHZvaWQgcWxhNHh4eF93YWtlX2Rw
YyhzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqaGEpCiAJCXF1ZXVlX3dvcmsoaGEtPmRwY190aHJlYWQs
ICZoYS0+ZHBjX3dvcmspOwogfQogCitzdGF0aWMgc3RydWN0IHFsYTRfd29ya19ldnQgKgorcWxh
NHh4eF9hbGxvY193b3JrKHN0cnVjdCBzY3NpX3FsYV9ob3N0ICpoYSwgdWludDMyX3QgZGF0YV9z
aXplLAorCQkgICBlbnVtIHFsYTRfd29ya190eXBlIHR5cGUpCit7CisJc3RydWN0IHFsYTRfd29y
a19ldnQgKmU7CisJdWludDMyX3Qgc2l6ZSA9IHNpemVvZihzdHJ1Y3QgcWxhNF93b3JrX2V2dCkg
KyBkYXRhX3NpemU7CisKKwllID0ga3phbGxvYyhzaXplLCBHRlBfQVRPTUlDKTsKKwlpZiAoIWUp
CisJCXJldHVybiBOVUxMOworCisJSU5JVF9MSVNUX0hFQUQoJmUtPmxpc3QpOworCWUtPnR5cGUg
PSB0eXBlOworCXJldHVybiBlOworfQorCitzdGF0aWMgdm9pZCBxbGE0eHh4X3Bvc3Rfd29yayhz
dHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqaGEsCisJCQkgICAgIHN0cnVjdCBxbGE0X3dvcmtfZXZ0ICpl
KQoreworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSgmaGEtPndv
cmtfbG9jaywgZmxhZ3MpOworCWxpc3RfYWRkX3RhaWwoJmUtPmxpc3QsICZoYS0+d29ya19saXN0
KTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYS0+d29ya19sb2NrLCBmbGFncyk7CisJcWxh
NHh4eF93YWtlX2RwYyhoYSk7Cit9CisKK2ludCBxbGE0eHh4X3Bvc3RfYWVuX3dvcmsoc3RydWN0
IHNjc2lfcWxhX2hvc3QgKmhhLAorCQkJICBlbnVtIGlzY3NpX2hvc3RfZXZlbnRfY29kZSBhZW5f
Y29kZSwKKwkJCSAgdWludDMyX3QgZGF0YV9zaXplLCB1aW50OF90ICpkYXRhKQoreworCXN0cnVj
dCBxbGE0X3dvcmtfZXZ0ICplOworCisJZSA9IHFsYTR4eHhfYWxsb2Nfd29yayhoYSwgZGF0YV9z
aXplLCBRTEE0X0VWRU5UX0FFTik7CisJaWYgKCFlKQorCQlyZXR1cm4gUUxBX0VSUk9SOworCisJ
ZS0+dS5hZW4uY29kZSA9IGFlbl9jb2RlOworCWUtPnUuYWVuLmRhdGFfc2l6ZSA9IGRhdGFfc2l6
ZTsKKwltZW1jcHkoZS0+dS5hZW4uZGF0YSwgZGF0YSwgZGF0YV9zaXplKTsKKworCXFsYTR4eHhf
cG9zdF93b3JrKGhhLCBlKTsKKworCXJldHVybiBRTEFfU1VDQ0VTUzsKK30KKwordm9pZCBxbGE0
eHh4X2RvX3dvcmsoc3RydWN0IHNjc2lfcWxhX2hvc3QgKmhhKQoreworCXN0cnVjdCBxbGE0X3dv
cmtfZXZ0ICplLCAqdG1wOworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJTElTVF9IRUFEKHdvcmsp
OworCisJc3Bpbl9sb2NrX2lycXNhdmUoJmhhLT53b3JrX2xvY2ssIGZsYWdzKTsKKwlsaXN0X3Nw
bGljZV9pbml0KCZoYS0+d29ya19saXN0LCAmd29yayk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmaGEtPndvcmtfbG9jaywgZmxhZ3MpOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGUs
IHRtcCwgJndvcmssIGxpc3QpIHsKKwkJbGlzdF9kZWxfaW5pdCgmZS0+bGlzdCk7CisKKwkJc3dp
dGNoIChlLT50eXBlKSB7CisJCWNhc2UgUUxBNF9FVkVOVF9BRU46CisJCQlpc2NzaV9wb3N0X2hv
c3RfZXZlbnQoaGEtPmhvc3Rfbm8sCisJCQkJCSAgICAgICZxbGE0eHh4X2lzY3NpX3RyYW5zcG9y
dCwKKwkJCQkJICAgICAgZS0+dS5hZW4uY29kZSwKKwkJCQkJICAgICAgZS0+dS5hZW4uZGF0YV9z
aXplLAorCQkJCQkgICAgICBlLT51LmFlbi5kYXRhKTsKKwkJCWJyZWFrOworCQlkZWZhdWx0Ogor
CQkJcWw0X3ByaW50ayhLRVJOX1dBUk5JTkcsIGhhLCAiZXZlbnQgdHlwZTogMHgleCBub3QgIgor
CQkJCSAgICJzdXBwb3J0ZWQiLCBlLT50eXBlKTsKKwkJfQorCQlrZnJlZShlKTsKKwl9Cit9CisK
IC8qKgogICogcWxhNHh4eF9kb19kcGMgLSBkcGMgcm91dGluZQogICogQGRhdGE6IGluIG91ciBj
YXNlIHBvaW50ZXIgdG8gYWRhcHRlciBzdHJ1Y3R1cmUKQEAgLTI4NzgsNiArMjk1Nyw5IEBAIHN0
YXRpYyB2b2lkIHFsYTR4eHhfZG9fZHBjKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJcmV0
dXJuOwogCX0KIAorCS8qIHBvc3QgZXZlbnRzIHRvIGFwcGxpY2F0aW9uICovCisJcWxhNHh4eF9k
b193b3JrKGhhKTsKKwogCWlmIChpc19xbGE4MDIyKGhhKSkgewogCQlpZiAodGVzdF9iaXQoRFBD
X0hBX1VOUkVDT1ZFUkFCTEUsICZoYS0+ZHBjX2ZsYWdzKSkgewogCQkJcWxhNF84eHh4X2lkY19s
b2NrKGhhKTsKQEAgLTQ0NTAsNiArNDUzMiw5IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHFsYTR4
eHhfcHJvYmVfYWRhcHRlcihzdHJ1Y3QgcGNpX2RldiAqcGRldiwKIAogCXNwaW5fbG9ja19pbml0
KCZoYS0+aGFyZHdhcmVfbG9jayk7CiAKKwkvKiBJbml0aWFsaXplIHdvcmsgbGlzdCAqLworCUlO
SVRfTElTVF9IRUFEKCZoYS0+d29ya19saXN0KTsKKwogCS8qIEFsbG9jYXRlIGRtYSBidWZmZXJz
ICovCiAJaWYgKHFsYTR4eHhfbWVtX2FsbG9jKGhhKSkgewogCQlxbDRfcHJpbnRrKEtFUk5fV0FS
TklORywgaGEsCi0tIAoxLjcuOC4yNDcuZzEwZjRlCgo=

--_002_CB5F15FFCA31vikaschaudharyqlogiccom_--
