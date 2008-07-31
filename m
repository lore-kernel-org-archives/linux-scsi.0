From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/2] scsi:netlink support in scsi and fc transports for hbaspecific messages
Date: Wed, 30 Jul 2008 22:09:51 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F511@xbl3.ma.emulex.com>
References: <1217454832.25166.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C8F2B2.842F631E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59712 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYGaCJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 22:09:58 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david.somayajulu@qlogic.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8F2B2.842F631E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

David,

I've had a similar patch floating around now for months, but it was
more for messages destined to the transport. It should easily extend
to driver messages too.

My approach had the drivers registering with the scsi netlink module
rather than using the host template (transports don't have a template,
so its either reg/dereg or a static table). Comparing the two, yours
seems cleaner, as the registration/deregistration creates some
headaches.=20
I'm a little bothered that there's nothing that qualifies the driver
to the shost before invoking the LLDD handler (e.g. driver has a
signature, message header contains signature, and the two must match).
But, perhaps that's livable. One thing yours doesn't do is communicate
netlink events to the consumers, so if they were tracking anything=20
by pid, they could clean up. You could add this, but it would mean
another template entry point.

I've attached my patch for comparison, although it would need work to
do what you are doing.  Anyone else with a preference on the approach ?

-- james s


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David=20
> Somayajulu
> Sent: Wednesday, July 30, 2008 5:54 PM
> To: linux-scsi@vger.kernel.org
> Cc: David Somayajulu; David Wagner
> Subject: [PATCH 1/2] scsi:netlink support in scsi and fc=20
> transports for hbaspecific messages
>=20
> This patch adds support to the scsi transport layer for=20
> passing hba specific netlink messages to a low level driver.=20
> Also support is added to the fc transport, to enable an FC=20
> hba driver to post netlink message to a specific user process.
>=20
> Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
> ---
>  drivers/scsi/scsi_netlink.c      |   13 +++++++
>  drivers/scsi/scsi_transport_fc.c |   72=20
> ++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_host.h         |    6 +++
>  include/scsi/scsi_netlink.h      |    3 +-
>  include/scsi/scsi_transport_fc.h |    2 +
>  5 files changed, 95 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
> index ae7ed9a..3bc85c9 100644
> --- a/drivers/scsi/scsi_netlink.c
> +++ b/drivers/scsi/scsi_netlink.c
> @@ -24,6 +24,7 @@
>  #include <net/sock.h>
>  #include <net/netlink.h>
> =20
> +#include <scsi/scsi_host.h>
>  #include <scsi/scsi_netlink.h>
>  #include "scsi_priv.h"
> =20
> @@ -47,6 +48,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>  	struct scsi_nl_hdr *hdr;
>  	uint32_t rlen;
>  	int err;
> +	struct Scsi_Host *shost;
> =20
>  	while (skb->len >=3D NLMSG_SPACE(0)) {
>  		err =3D 0;
> @@ -89,6 +91,17 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>  		/*
>  		 * We currently don't support anyone sending us=20
> a message
>  		 */
> +		if (hdr->msgtype =3D=3D SCSI_NL_HOST_PRIVATE) {
> +			shost =3D scsi_host_lookup(hdr->host_no);
> +			if (!shost) {
> +				printk(KERN_ERR "%s:=20
> scsi_host_lookup failed "
> +					"host no %u\n",=20
> __FUNCTION__, hdr->host_no);
> +			} else if (shost->hostt->netlink_rcv_msg) {
> +				err =3D=20
> shost->hostt->netlink_rcv_msg(shost,
> +					(void *)((char=20
> *)hdr+sizeof(*hdr)),
> +					hdr->msglen,=20
> NETLINK_CREDS(skb)->pid);
> +			}
> +		}
> =20
>  next_msg:
>  		if ((err) || (nlh->nlmsg_flags & NLM_F_ACK))
> diff --git a/drivers/scsi/scsi_transport_fc.c=20
> b/drivers/scsi/scsi_transport_fc.c
> index cb971f0..d1b38d9 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -627,6 +627,78 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
> =20
> =20
> =20
> +/**
> + * fc_host_post_vendor_event_to_pid - called to post a=20
> vendor unique event
> + *			on an fc_host to a specific process
> + * @shost:		host the event occurred on
> + * @event_number:	fc event number obtained from=20
> get_fc_event_number()
> + * @data_len:		amount, in bytes, of vendor unique data
> + * @data_buf:		pointer to vendor unique data
> + * @vendor_id:          Vendor id
> + * @pid:		proc id of the receiver
> + *
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + */
> +void
> +fc_host_post_vendor_event_to_pid(struct Scsi_Host *shost,=20
> u32 event_number,
> +		u32 data_len, char * data_buf, u64 vendor_id,=20
> uint32_t pid)
> +{
> +	struct sk_buff *skb;
> +	struct nlmsghdr	*nlh;
> +	struct fc_nl_event *event;
> +	u32 len, skblen;
> +	int err;
> +
> +	if (!scsi_nl_sock) {
> +		err =3D -ENOENT;
> +		goto send_vendor_fail;
> +	}
> +
> +	len =3D FC_NL_MSGALIGN(sizeof(*event) + data_len);
> +	skblen =3D NLMSG_SPACE(len);
> +
> +	skb =3D alloc_skb(skblen, GFP_KERNEL);
> +	if (!skb) {
> +		err =3D -ENOBUFS;
> +		goto send_vendor_fail;
> +	}
> +
> +	nlh =3D nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
> +				skblen - sizeof(*nlh), 0);
> +	if (!nlh) {
> +		err =3D -ENOBUFS;
> +		goto send_vendor_fail_skb;
> +	}
> +	event =3D NLMSG_DATA(nlh);
> +
> +	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
> +				FC_NL_ASYNC_EVENT, len);
> +	event->seconds =3D get_seconds();
> +	event->vendor_id =3D vendor_id;
> +	event->host_no =3D shost->host_no;
> +	event->event_datalen =3D data_len;	/* bytes */
> +	event->event_num =3D event_number;
> +	event->event_code =3D FCH_EVT_VENDOR_UNIQUE;
> +	memcpy(&event->event_data, data_buf, data_len);
> +
> +	err =3D nlmsg_unicast(scsi_nl_sock, skb, pid);
> +	if (err && (err !=3D -ESRCH))	/* filter no recipient errors */
> +		/* nlmsg_multicast already kfree_skb'd */
> +		goto send_vendor_fail;
> +
> +	return;
> +
> +send_vendor_fail_skb:
> +	kfree_skb(skb);
> +send_vendor_fail:
> +	printk(KERN_WARNING
> +		"%s: Dropped Event : host %d vendor_unique - err %d\n",
> +		__FUNCTION__, shost->host_no, err);
> +	return;
> +}
> +EXPORT_SYMBOL(fc_host_post_vendor_event_to_pid);
> +
>  static __init int fc_transport_init(void)
>  {
>  	int error;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 44a55d1..04afe93 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -485,6 +485,12 @@ struct scsi_host_template {
>  	 * module_init/module_exit.
>  	 */
>  	struct list_head legacy_hosts;
> +	/*
> +	 * passes host specific to netlink messages received on=20
> scsi_nl_sock
> +	 * to the LLD
> +	 */
> +	int (* netlink_rcv_msg)(struct Scsi_Host *, void=20
> *payload, uint32_t len,
> +				uint32_t pid);
>  };
> =20
>  /*
> diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
> index 8c1470c..b32596e 100644
> --- a/include/scsi/scsi_netlink.h
> +++ b/include/scsi/scsi_netlink.h
> @@ -42,6 +42,7 @@ struct scsi_nl_hdr {
>  	uint16_t magic;
>  	uint16_t msgtype;
>  	uint16_t msglen;
> +	uint16_t host_no;
>  } __attribute__((aligned(sizeof(uint64_t))));
> =20
>  /* scsi_nl_hdr->version value */
> @@ -56,7 +57,7 @@ struct scsi_nl_hdr {
>  #define SCSI_NL_MAX_TRANSPORTS			2
> =20
>  /* scsi_nl_hdr->msgtype values are defined in each transport */
> -
> +#define SCSI_NL_HOST_PRIVATE			1
> =20
>  /*
>   * Vendor ID:
> diff --git a/include/scsi/scsi_transport_fc.h=20
> b/include/scsi/scsi_transport_fc.h
> index 21018a4..217fdc9 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -747,6 +747,8 @@ void fc_host_post_event(struct Scsi_Host=20
> *shost, u32 event_number,
>  		enum fc_host_event_code event_code, u32 event_data);
>  void fc_host_post_vendor_event(struct Scsi_Host *shost, u32=20
> event_number,
>  		u32 data_len, char * data_buf, u64 vendor_id);
> +void fc_host_post_vendor_event_to_pid(struct Scsi_Host=20
> *shost, u32 event_number,
> +                u32 data_len, char * data_buf, u64=20
> vendor_id, uint32_t pid);
>  	/* Note: when specifying vendor_id to=20
> fc_host_post_vendor_event()
>  	 *   be sure to read the Vendor Type and ID formatting=20
> requirements
>  	 *   specified in scsi_netlink.h
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

------_=_NextPart_001_01C8F2B2.842F631E
Content-Type: text/plain;
	name="RFC for SCSI netlink expansion.txt"
Content-Transfer-Encoding: base64
Content-Description: RFC for SCSI netlink expansion.txt
Content-Disposition: attachment;
	filename="RFC for SCSI netlink expansion.txt"

LS0tIHNjc2lfbmV0bGluay5jLm9yaWcgMjAwOC0wNS0yMSAxMDozNDo1MS42MDIwODQwMDAgLTA0
MDANCisrKyBzY3NpX25ldGxpbmsuYyAgICAgIDIwMDgtMDUtMjcgMTE6MzM6NDYuNjQ5NjY4MDAw
IC0wNDAwDQpAQCAtMjksNyArMjksMTAgQEANCiANCiBzdHJ1Y3Qgc29jayAqc2NzaV9ubF9zb2Nr
ID0gTlVMTDsNCiBFWFBPUlRfU1lNQk9MX0dQTChzY3NpX25sX3NvY2spOw0KLQ0KK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbmxfdHJhbnNwb3J0X2Z1bmNzIG5sX2Z1bmNbU0NTSV9OTF9NQVhfVFJBTlNQ
T1JUU10NCj0gew0KKyAgICAgICBbU0NTSV9OTF9UUkFOU1BPUlRdICAgICA9IHsgTlVMTCwgTlVM
TCB9LA0KKyAgICAgICBbU0NTSV9OTF9UUkFOU1BPUlRfRkNdICA9IHsgTlVMTCwgTlVMTCB9LA0K
K307DQogDQogLyoqDQogICogc2NzaV9ubF9yY3ZfbXNnIC0gUmVjZWl2ZSBtZXNzYWdlIGhhbmRs
ZXIuDQpAQCAtNjUsNyArNjgsNyBAQA0KIA0KICAgICAgICAgICAgICAgIGlmIChubGgtPm5sbXNn
X3R5cGUgIT0gU0NTSV9UUkFOU1BPUlRfTVNHKSB7DQogICAgICAgICAgICAgICAgICAgICAgICBl
cnIgPSAtRUJBRE1TRzsNCi0gICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsNCisgICAgICAg
ICAgICAgICAgICAgICAgIGdvdG8gbmV4dF9tc2c7DQogICAgICAgICAgICAgICAgfQ0KIA0KICAg
ICAgICAgICAgICAgIGhkciA9IE5MTVNHX0RBVEEobmxoKTsNCkBAIC04NiwxMCArODksMTYgQEAN
CiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsNCiAgICAgICAgICAgICAgICB9DQogDQot
ICAgICAgICAgICAgICAgLyoNCi0gICAgICAgICAgICAgICAgKiBXZSBjdXJyZW50bHkgZG9uJ3Qg
c3VwcG9ydCBhbnlvbmUgc2VuZGluZyB1cyBhDQptZXNzYWdlDQotICAgICAgICAgICAgICAgICov
DQotDQorICAgICAgICAgICAgICAgaWYgKGhkci0+dHJhbnNwb3J0IDwgU0NTSV9OTF9NQVhfVFJB
TlNQT1JUUykgew0KKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKG5sX2Z1bmNbaGRyLT50cmFu
c3BvcnRdLm5sX3Jjdl9tc2cpDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5sX2Z1
bmNbaGRyLT50cmFuc3BvcnRdLm5sX3Jjdl9tc2cobmxoKTsNCisgICAgICAgICAgICAgICAgICAg
ICAgIGVsc2UNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJpbnRrKEtFUk5fRVJS
DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiJXM6IE5VTEwgbmV0bGlu
ayByY3YgZnVuY3Rpb24NCiglZClcbiIsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBfX2Z1bmNfXywgaGRyLT50cmFuc3BvcnQpOw0KKyAgICAgICAgICAgICAgIH0gZWxz
ZQ0KKyAgICAgICAgICAgICAgICAgICAgICAgcHJpbnRrKEtFUk5fRVJSICIlczogSW52YWxpZCB0
cmFuc3BvcnQgSUQ6DQolZFxuIiwNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1
bmNfXywgaGRyLT50cmFuc3BvcnQpOw0KIG5leHRfbXNnOg0KICAgICAgICAgICAgICAgIGlmICgo
ZXJyKSB8fCAobmxoLT5ubG1zZ19mbGFncyAmIE5MTV9GX0FDSykpDQogICAgICAgICAgICAgICAg
ICAgICAgICBuZXRsaW5rX2Fjayhza2IsIG5saCwgZXJyKTsNCkBAIC0xMTAsMTQgKzExOSwxNSBA
QA0KIHNjc2lfbmxfcmN2X2V2ZW50KHN0cnVjdCBub3RpZmllcl9ibG9jayAqdGhpcywgdW5zaWdu
ZWQgbG9uZyBldmVudCwNCnZvaWQgKnB0cikNCiB7DQogICAgICAgIHN0cnVjdCBuZXRsaW5rX25v
dGlmeSAqbiA9IHB0cjsNCisgICAgICAgaW50IGk7DQogDQogICAgICAgIGlmIChuLT5wcm90b2Nv
bCAhPSBORVRMSU5LX1NDU0lUUkFOU1BPUlQpDQogICAgICAgICAgICAgICAgcmV0dXJuIE5PVElG
WV9ET05FOw0KIA0KLSAgICAgICAvKg0KLSAgICAgICAgKiBDdXJyZW50bHksIHdlIGFyZSBub3Qg
dHJhY2tpbmcgUElEJ3MsIGV0Yy4gVGhlcmUgaXMgbm90aGluZw0KLSAgICAgICAgKiB0byBoYW5k
bGUuDQotICAgICAgICAqLw0KKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgU0NTSV9OTF9NQVhfVFJB
TlNQT1JUUzsgaSsrKSB7DQorICAgICAgICAgICAgICAgaWYgKG5sX2Z1bmNbaV0ubmxfcmN2X2V2
ZW50KQ0KKyAgICAgICAgICAgICAgICAgICAgICAgbmxfZnVuY1tpXS5ubF9yY3ZfZXZlbnQoZXZl
bnQsIHB0cik7DQorICAgICAgIH0NCiANCiAgICAgICAgcmV0dXJuIE5PVElGWV9ET05FOw0KIH0N
CkBAIC0xNzEsNCArMTgxLDY2IEBADQogICAgICAgIHJldHVybjsNCiB9DQogDQorLyoqDQorICog
c2NzaV9uZXRsaW5rX2FkZF90cmFuc3BvcnQgLSBhZGRzIGEgdHJhbnNwb3J0IHRvIHRoZSBTQ1NJ
IG5ldGxpbmsNCm11bHRpcGxleGVyDQorICogQHRyYW5zcG9ydF9pZDogICAgICBUaGUgdHJhbnNw
b3J0IElEIGRlZmluZWQgaW4gc2NzaV9uZXRsaW5rLmggdGhhdA0KKyAqICAgIGNvcnJlc3BvbmRz
IHRvIHRoZSB0cmFuc3BvcnQuIFRoaXMgdmFsdWUgaXMgdXNlZCBieSBhcHBsaWNhdGlvbnMNCnNl
bmRpbmcNCisgKiAgICBuZXRsaW5rIG1lc3NhZ2VzIHRvIGRpcmVjdCB0aGVtIHRvIHRoZSBjb3Jy
ZWN0IHRyYW5zcG9ydC4NCisgKiBAbmxfcmN2X21zZzogICAgICAgICAgICAgICAgVGhlIHRyYW5z
cG9ydCdzIG5ldGxpbmsgcmVjZWl2ZSBtZXNzYWdlDQpmdW5jdGlvbi4NCisgKiBAbmxfcmN2X2V2
ZW50OiAgICAgIFRoZSB0cmFuc3BvcnQncyBuZXRsaW5rIHJlY2VpdmUgZXZlbnQgZnVuY3Rpb24u
DQorICoNCisgKiBEZXNjcmlwdGlvbjoNCisgKiBUaGlzIGZ1bmN0aW9uIHJlZ2lzdGVycyBuZXRs
aW5rIHJlY2VpdmUgZnVuY3Rpb25zIGZvciBhIHRyYW5zcG9ydA0KdHlwZS4gT25jZQ0KKyAqIGNh
bGxlZCB0aGUgU0NTSSBuZXRsaW5rIGNvZGUgd2lsbCBmb3J3YXJkIGFsbCByZWNlaXZlZCBuZXRs
aW5rDQptZXNzYWdlcyB3aXRoDQorICogYSB0cmFuc3BvcnQgdmFsdWUgb2YgQHRyYW5zcG9ydF9p
ZCB0byBAbmxfcmN2X2Z1bmMuIEFsbCBTQ1NJIG5ldGxpbmsNCmV2ZW50cw0KKyAqIHdpbGwgYmUg
Zm9yd2FyZGVkIHRvIHRoZSBAbmxfcmN2X2V2ZW50IGZ1bmN0aW9uLg0KKyAqDQorICogUmV0dXJu
Og0KKyAqIEEgcmV0dXJuIHZhbHVlIG9mIHplcm8gaW5kaWNhdGVzIHN1Y2Nlc3NmdWwgcmVnaXN0
cmF0aW9uIG9mIG5ldGxpbmsNCnJlY2VpdmUNCisgKiBmdW5jdGlvbnMuIEEgbm9uLXplcm8gdmFs
dWUgaW5kaWNhdGVzIGFuIGVycm9yIHdpdGggaW5wdXQNCnBhcmFtZXRlcnMuDQorICovDQoraW50
DQorc2NzaV9uZXRsaW5rX2FkZF90cmFuc3BvcnQoaW50IHRyYW5zcG9ydF9pZCwNCisgICAgICAg
ICAgICAgICAgICAgICAgICAgIGludCAoKm5sX3Jjdl9tc2cpKHZvaWQgKiksDQorICAgICAgICAg
ICAgICAgICAgICAgICAgICBpbnQgKCpubF9yY3ZfZXZlbnQpKHVuc2lnbmVkIGxvbmcsIHZvaWQg
KikpDQorew0KKyAgICAgICBpZiAodHJhbnNwb3J0X2lkID49IFNDU0lfTkxfTUFYX1RSQU5TUE9S
VFMpIHsNCisgICAgICAgICAgICAgICBwcmludGsoS0VSTl9FUlIgIiVzOiBJbnZhbGlkIHRyYW5z
cG9ydCBJRDolZCIsDQorICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCB0cmFuc3BvcnRf
aWQpOw0KKyAgICAgICAgICAgICAgIHJldHVybiBFSU5WQUw7DQorICAgICAgIH0NCisgICAgICAg
aWYgKG5sX2Z1bmNbdHJhbnNwb3J0X2lkXS5ubF9yY3ZfbXNnICE9IE5VTEwgfHwNCisgICAgICAg
ICAgIG5sX2Z1bmNbdHJhbnNwb3J0X2lkXS5ubF9yY3ZfZXZlbnQgIT0gTlVMTCkgew0KKyAgICAg
ICAgICAgICAgIHByaW50ayhLRVJOX0VSUiAiJXM6IFRyYW5zcG9ydCAoJWQpIGFscmVhZHkgcmVn
aXN0ZXJlZCIsDQorICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCB0cmFuc3BvcnRfaWQp
Ow0KKyAgICAgICAgICAgICAgIHJldHVybiBFSU5WQUw7DQorICAgICAgIH0NCisgICAgICAgbmxf
ZnVuY1t0cmFuc3BvcnRfaWRdLm5sX3Jjdl9tc2cgPSBubF9yY3ZfbXNnOw0KKyAgICAgICBubF9m
dW5jW3RyYW5zcG9ydF9pZF0ubmxfcmN2X2V2ZW50ID0gbmxfcmN2X2V2ZW50Ow0KKyAgICAgICBy
ZXR1cm4gMDsNCit9DQorRVhQT1JUX1NZTUJPTChzY3NpX25ldGxpbmtfYWRkX3RyYW5zcG9ydCk7
DQogDQorLyoqDQorICogc2NzaV9uZXRsaW5rX3JlbW92ZV90cmFuc3BvcnQgLSByZW1vdmVzIGFu
IGVudHJ5IGZyb20gdGhlIG5ldGxpbmsNCm11bHRpcGxleGVyDQorICogQHRyYW5zcG9ydF9pZDog
ICAgICBUaGUgdHJhbnNwb3J0IElEIGRlZmluZWQgaW4gc2NzaV9uZXRsaW5rLmggdGhhdA0KKyAq
ICAgICBjb3JyZXNwb25kcyB0byB0aGUgdHJhbnNwb3J0LiBUaGlzIHZhbHVlIGlzIHVzZWQgYnkg
YXBwbGljYXRpb25zDQpzZW5kaW5nDQorICogICAgIG5ldGxpbmsgbWVzc2FnZXMgdG8gZGlyZWN0
IHRoZW0gdG8gdGhlIGNvcnJlY3QgdHJhbnNwb3J0Lg0KKyAqDQorICogRGVzY3JpcHRpb246DQor
ICogT25jZSBjYWxsZWQgdGhlIHRyYW5zcG9ydCBpbmRpY2F0ZWQgYnkgQHRyYW5zcG9ydF9pZCB3
aWxsIG5vIGxvbmdlcg0KcmVjZWl2ZQ0KKyAqIGluY29taW5nIG5ldGxpbmsgbWVzc2FnZXMgZnJv
bSB0aGUgU0NTSSB0cmFuc3BvcnQgbmV0bGluay4NCisgKi8NCitpbnQNCitzY3NpX25ldGxpbmtf
cmVtb3ZlX3RyYW5zcG9ydChpbnQgdHJhbnNwb3J0X2lkKQ0KK3sNCisgICAgICAgaWYgKHRyYW5z
cG9ydF9pZCA+PSBTQ1NJX05MX01BWF9UUkFOU1BPUlRTKSB7DQorICAgICAgICAgICAgICAgcHJp
bnRrKEtFUk5fRVJSICIlczogSW52YWxpZCB0cmFuc3BvcnQgSUQ6JWQiLA0KKyAgICAgICAgICAg
ICAgICAgICAgICBfX2Z1bmNfXywgdHJhbnNwb3J0X2lkKTsNCisgICAgICAgICAgICAgICByZXR1
cm4gRUlOVkFMOw0KKyAgICAgICB9DQorICAgICAgIG5sX2Z1bmNbdHJhbnNwb3J0X2lkXS5ubF9y
Y3ZfbXNnID0gTlVMTDsNCisgICAgICAgbmxfZnVuY1t0cmFuc3BvcnRfaWRdLm5sX3Jjdl9ldmVu
dCA9IE5VTEw7DQorICAgICAgIHJldHVybiAwOw0KK30NCitFWFBPUlRfU1lNQk9MKHNjc2lfbmV0
bGlua19yZW1vdmVfdHJhbnNwb3J0KTsNCg0KLS0tIHNjc2lfbmV0bGluay5oLm9yaWcgMjAwOC0w
NS0yMSAxMDozNzozNC42MzU1ODYwMDAgLTA0MDANCisrKyBzY3NpX25ldGxpbmsuaCAgICAgIDIw
MDgtMDUtMjcgMTE6MzI6MjMuMzE4NzQ0MDAwIC0wNDAwDQpAQCAtNTUsNiArNTUsMTEgQEANCiAj
ZGVmaW5lIFNDU0lfTkxfVFJBTlNQT1JUX0ZDICAgICAgICAgICAgICAgICAgIDENCiAjZGVmaW5l
IFNDU0lfTkxfTUFYX1RSQU5TUE9SVFMgICAgICAgICAgICAgICAgIDINCiANCitzdHJ1Y3Qgbmxf
dHJhbnNwb3J0X2Z1bmNzIHsNCisgICAgICAgaW50ICAgICAoKm5sX3Jjdl9tc2cpKHZvaWQgKik7
DQorICAgICAgIGludCAgICAgKCpubF9yY3ZfZXZlbnQpKHVuc2lnbmVkIGxvbmcsIHZvaWQgKik7
DQorfTsNCisNCiAvKiBzY3NpX25sX2hkci0+bXNndHlwZSB2YWx1ZXMgYXJlIGRlZmluZWQgaW4g
ZWFjaCB0cmFuc3BvcnQgKi8NCiANCiANCkBAIC04Miw2ICs4NywxMCBAQA0KICAgICAgICAoaGRy
KS0+bXNnbGVuID0gbWxlbjsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAg
ICAgICAgfQ0KIA0KK2ludCBzY3NpX25ldGxpbmtfYWRkX3RyYW5zcG9ydChpbnQgdHJhbnNwb3J0
X2lkLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCAoKikodm9pZCAqKSwNCisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgKCopKHVuc2lnbmVkIGxvbmcsIHZvaWQg
KikpOw0KK2ludCBzY3NpX25ldGxpbmtfcmVtb3ZlX3RyYW5zcG9ydChpbnQpOw0KIA0KICNlbmRp
ZiAvKiBTQ1NJX05FVExJTktfSCAqLw0KDQoNCg==

------_=_NextPart_001_01C8F2B2.842F631E--
