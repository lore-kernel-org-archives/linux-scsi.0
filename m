From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: remove pigs in space
Date: Wed, 16 Jan 2008 07:39:06 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439065895@ADPE2K703.adaptec.com>
References: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
 <a789287f8ac2eef0d95c6cbb08f68c122b5f7ec4.tomof@acm.org>
 <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA880@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F438E4653A@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F439065895ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:60748 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYAPPjM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 10:39:12 -0500
Received: from ADPE2K701.adaptec.com (adpe2k701.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 8101B247C83
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jan 2008 07:39:09 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F438E4653A@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439065895ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I was amazed at how much embedded space was present in the aacraid driver s=
ource files. Just selected five files from the set to clean up for now and =
the attached patch swelled to 73K in size!

- Removed trailing space or tabs
- Removed spaces embedded within tabs
- Replaced leading 8 spaces with tabs
- Removed spaces before )
- Removed ClusterCommand as it was unused (noticed it as one triggered by a=
bove)
- Replaced scsi_status comparison with 0x02, to compare against SAM_STATUS_=
CHECK_CONDITION.
- Replaced a long series of spaces with tabs
- Replaced some simple if...defined() with ifdef/ifndef

All of this is code inert. I understand such sweeping patches make it hard =
to pick code changes from the space removal chaff. Also, I have NOT checked=
 this with checkpatch.pl, as this patch's size would probably bloat further=
 enforcing additional style changes. If this is unacceptable, then No Big D=
eal, this is but a trial balloon in this case with no harm or foul. The in-=
tree space savings are less than a block size in granularity, so there is n=
o 'real-life' savings introduced by this patch, just some peace of mind ;->

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments.

Do not use the in-line patch as source, it is a diff -rub (ignore spaces) t=
o capture the style or trickier changes in the attached patch to make it ea=
sier to inspect.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c   |  243 +++++++++++++++----------------
 drivers/scsi/aacraid/aacraid.h  |  310 +++++++++++++++++++----------------=
-----
 drivers/scsi/aacraid/commctrl.c |   80 +++++-----
 drivers/scsi/aacraid/commsup.c  |  202 +++++++++++++-------------
 drivers/scsi/aacraid/linit.c    |   88 +++++------
 5 files changed, 461 insertions(+), 462 deletions(-)

diff -rub a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c  2008-01-16 09:28:08.244836183 -0500
+++ b/drivers/scsi/aacraid/aachba.c  2008-01-16 10:08:02.185944381 -0500
@@ -196,7 +196,7 @@
                struct fib *fibptr) {
        struct scsi_device *device;

-       if (unlikely(!scsicmd || !scsicmd->scsi_done )) {
+       if (unlikely(!scsicmd || !scsicmd->scsi_done)) {
                dprintk((KERN_WARNING "aac_valid_context: scsi command corr=
upt\n"));
                 aac_fib_complete(fibptr);
                 aac_fib_free(fibptr);
@@ -243,7 +243,7 @@
                            FsaNormal,
                            1, 1,
                            NULL, NULL);
-       if (status < 0 ) {
+       if (status < 0) {
                printk(KERN_WARNING "aac_get_config_status: SendFIB failed.=
\n");
        } else {
                struct aac_get_config_status_resp *reply
@@ -439,7 +439,7 @@
                  sizeof (struct aac_get_name),
                  FsaNormal,
                  0, 1,
-                 (fib_callback) get_container_name_callback,
+                 (fib_callback)get_container_name_callback,
                  (void *) scsicmd);

        /*
@@ -663,7 +663,7 @@
 static void inqstrcpy(char *a, char *b)
 {

-       while(*a !=3D (char)0)
+       while (*a !=3D (char)0)
                *b++ =3D *a++;
 }

@@ -1963,7 +1963,7 @@
                dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", cid));
                memset(&inq_data, 0, sizeof (struct inquiry_data));

-               if (scsicmd->cmnd[1] & 0x1 ) {
+               if (scsicmd->cmnd[1] & 0x1) {
                        char *arr =3D (char *)&inq_data;

                        /* EVPD bit set */
@@ -2442,7 +2442,7 @@
                case  WRITE_12:
                case  READ_16:
                case  WRITE_16:
-                       if(le32_to_cpu(srbreply->data_xfer_length) < scsicm=
d->underflow ) {
+                       if(le32_to_cpu(srbreply->data_xfer_length) < scsicm=
d->underflow) {
                                printk(KERN_WARNING"aacraid: SCSI CMD under=
flow\n");
                        } else {
                                printk(KERN_WARNING"aacraid: SCSI CMD Data =
Overrun\n");
@@ -2518,7 +2518,7 @@
                scsicmd->result =3D DID_ERROR << 16 | COMMAND_COMPLETE << 8=
;
                break;
        }
-       if (le32_to_cpu(srbreply->scsi_status) =3D=3D 0x02 ){  // Check Con=
dition
+       if (le32_to_cpu(srbreply->scsi_status) =3D=3D SAM_STAT_CHECK_CONDIT=
ION) {
                int len;
                scsicmd->result |=3D SAM_STAT_CHECK_CONDITION;
                len =3D min_t(u32, le32_to_cpu(srbreply->sense_data_size),
diff -rub a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h 2008-01-16 09:28:08.244836183 -0500
+++ b/drivers/scsi/aacraid/aacraid.h 2008-01-16 10:00:51.893616629 -0500
@@ -1,4 +1,4 @@
-#if (!defined(dprintk))
+#ifndef dprintk
 # define dprintk(x)
 #endif
 /* eg: if (nblank(dprintk(x))) */
@@ -350,10 +350,6 @@
 #define                ContainerCommand64              501
 #define                ContainerRawIo                  502
 /*
- *     Cluster Commands
- */
-#define                ClusterCommand                  550
-/*
  *     Scsi Port commands (scsi passthrough)
  */
 #define                ScsiPortCommand                 600
@@ -994,7 +990,7 @@
        /*
         *      The following is the device specific extension.
         */
-#if (!defined(AAC_MIN_FOOTPRINT_SIZE))
+#ifndef AAC_MIN_FOOTPRINT_SIZE
 #      define AAC_MIN_FOOTPRINT_SIZE 8192
 #endif
        union
diff -rub a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl=
.c
--- a/drivers/scsi/aacraid/commctrl.c        2008-01-16 09:28:08.245836057 =
-0500
+++ b/drivers/scsi/aacraid/commctrl.c        2008-01-16 10:08:41.498951119 =
-0500
@@ -430,7 +430,7 @@
        version +=3D simple_strtol(driver_version + 1, &driver_version, 10)=
 << 16;
        version +=3D simple_strtol(driver_version + 1, NULL, 10);
        response.version =3D cpu_to_le32(version);
-#      if (defined(AAC_DRIVER_BUILD))
+#      ifdef AAC_DRIVER_BUILD
                response.build =3D cpu_to_le32(AAC_DRIVER_BUILD);
 #      else
                response.build =3D cpu_to_le32(9999);
@@ -593,7 +593,7 @@
                                sg_list[i] =3D p; // save so we can clean u=
p later
                                sg_indx =3D i;

-                               if( flags & SRB_DataOut ){
+                               if (flags & SRB_DataOut) {
                                        if(copy_from_user(p,sg_user[i],upsg=
->sg[i].count)){
                                                dprintk((KERN_DEBUG"aacraid=
: Could not copy sg data from user\n"));
                                                rcode =3D -EFAULT;
@@ -636,7 +636,7 @@
                                sg_list[i] =3D p; // save so we can clean u=
p later
                                sg_indx =3D i;

-                               if( flags & SRB_DataOut ){
+                               if (flags & SRB_DataOut) {
                                        if(copy_from_user(p,sg_user[i],upsg=
->sg[i].count)){
                                                kfree (usg);
                                                dprintk((KERN_DEBUG"aacraid=
: Could not copy sg data from user\n"));
@@ -679,7 +679,7 @@
                                sg_list[i] =3D p; // save so we can clean u=
p later
                                sg_indx =3D i;

-                               if( flags & SRB_DataOut ){
+                               if (flags & SRB_DataOut) {
                                        if(copy_from_user(p,sg_user[i],usg-=
>sg[i].count)){
                                                dprintk((KERN_DEBUG"aacraid=
: Could not copy sg data from user\n"));
                                                rcode =3D -EFAULT;
@@ -707,7 +707,7 @@
                                sg_list[i] =3D p; // save so we can clean u=
p later
                                sg_indx =3D i;

-                               if( flags & SRB_DataOut ){
+                               if (flags & SRB_DataOut) {
                                        if(copy_from_user(p, sg_user[i],
                                                        upsg->sg[i].count))=
 {
                                                dprintk((KERN_DEBUG"aacraid=
: Could not copy sg data from user\n"));
@@ -738,7 +738,7 @@
                goto cleanup;
        }

-       if( flags & SRB_DataIn ) {
+       if (flags & SRB_DataIn) {
                for(i =3D 0 ; i <=3D sg_indx; i++){
                        byte_count =3D le32_to_cpu(
                          (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64=
)
diff -rub a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c 2008-01-16 09:28:08.246835930 -0500
+++ b/drivers/scsi/aacraid/commsup.c 2008-01-16 10:08:57.925864695 -0500
@@ -116,7 +116,9 @@
        /*
         *      Initialise the fibs
         */
-       for (i =3D 0, fibptr =3D &dev->fibs[i]; i < (dev->scsi_host_ptr->ca=
n_queue + AAC_NUM_MGT_FIB); i++, fibptr++)
+       for (i =3D 0, fibptr =3D &dev->fibs[i];
+               i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+               i++, fibptr++)
        {
                fibptr->dev =3D dev;
                fibptr->hw_fib_va =3D hw_fib;
@@ -291,7 +293,8 @@
                        *index =3D 0; /* Wrap to front of the Producer Queu=
e. */
        }

-        if ((*index + 1) =3D=3D le32_to_cpu(*(q->headers.consumer))) { /* =
Queue is full */
+       /* Queue is full */
+       if ((*index + 1) =3D=3D le32_to_cpu(*(q->headers.consumer))) {
                printk(KERN_WARNING "Queue %d full, %u outstanding.\n",
                                qid, q->numpending);
                return 0;
@@ -637,7 +640,7 @@
        /*
         *      If we plan to do anything check the structure type first.
         */
-       if ( hw_fib->header.StructType !=3D FIB_MAGIC ) {
+       if (hw_fib->header.StructType !=3D FIB_MAGIC) {
                if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE)
                        kfree (hw_fib);
                return -EINVAL;
@@ -672,7 +675,8 @@
        }
        else
        {
-               printk(KERN_WARNING "aac_fib_adapter_complete: Unknown xfer=
state detected.\n");
+               printk(KERN_WARNING "aac_fib_adapter_complete: "
+                       "Unknown xferstate detected.\n");
                BUG();
        }
        return 0;
@@ -1510,7 +1514,7 @@
                        hw_fib =3D fib->hw_fib_va;
                        memset(fib, 0, sizeof(struct fib));
                        fib->type =3D FSAFS_NTC_FIB_CONTEXT;
-                       fib->size =3D sizeof( struct fib );
+                       fib->size =3D sizeof(struct fib);
                        fib->hw_fib_va =3D hw_fib;
                        fib->data =3D hw_fib->data;
                        fib->dev =3D dev;

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439065895ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_pigs_in_space.patch"
Content-Description: aacraid_pigs_in_space.patch
Content-Disposition: attachment; filename="aacraid_pigs_in_space.patch";
	size=75233; creation-date="Wed, 16 Jan 2008 07:09:42 GMT";
	modification-date="Wed, 16 Jan 2008 07:09:42 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMTYgMDk6Mjg6MDguMjQ0ODM2MTgzIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMTYgMTA6MDg6MDIuMTg1OTQ0MzgxIC0wNTAwCkBAIC01Niw1NCAr
NTYsNTQgQEAKIC8qCiAgKglTZW5zZSBjb2RlcwogICovCi0gCi0jZGVmaW5lIFNFTkNPREVfTk9f
U0VOU0UgICAgICAgICAgICAgICAgICAgICAgICAweDAwCi0jZGVmaW5lIFNFTkNPREVfRU5EX09G
X0RBVEEgICAgICAgICAgICAgICAgICAgICAweDAwCi0jZGVmaW5lIFNFTkNPREVfQkVDT01JTkdf
UkVBRFkgICAgICAgICAgICAgICAgICAweDA0Ci0jZGVmaW5lIFNFTkNPREVfSU5JVF9DTURfUkVR
VUlSRUQgICAgICAgICAgICAgICAweDA0Ci0jZGVmaW5lIFNFTkNPREVfUEFSQU1fTElTVF9MRU5H
VEhfRVJST1IgICAgICAgICAweDFBCi0jZGVmaW5lIFNFTkNPREVfSU5WQUxJRF9DT01NQU5EICAg
ICAgICAgICAgICAgICAweDIwCi0jZGVmaW5lIFNFTkNPREVfTEJBX09VVF9PRl9SQU5HRSAgICAg
ICAgICAgICAgICAweDIxCi0jZGVmaW5lIFNFTkNPREVfSU5WQUxJRF9DREJfRklFTEQgICAgICAg
ICAgICAgICAweDI0Ci0jZGVmaW5lIFNFTkNPREVfTFVOX05PVF9TVVBQT1JURUQgICAgICAgICAg
ICAgICAweDI1Ci0jZGVmaW5lIFNFTkNPREVfSU5WQUxJRF9QQVJBTV9GSUVMRCAgICAgICAgICAg
ICAweDI2Ci0jZGVmaW5lIFNFTkNPREVfUEFSQU1fTk9UX1NVUFBPUlRFRCAgICAgICAgICAgICAw
eDI2Ci0jZGVmaW5lIFNFTkNPREVfUEFSQU1fVkFMVUVfSU5WQUxJRCAgICAgICAgICAgICAweDI2
Ci0jZGVmaW5lIFNFTkNPREVfUkVTRVRfT0NDVVJSRUQgICAgICAgICAgICAgICAgICAweDI5Ci0j
ZGVmaW5lIFNFTkNPREVfTFVOX05PVF9TRUxGX0NPTkZJR1VSRURfWUVUICAgICAweDNFCi0jZGVm
aW5lIFNFTkNPREVfSU5RVUlSWV9EQVRBX0NIQU5HRUQgICAgICAgICAgICAweDNGCi0jZGVmaW5l
IFNFTkNPREVfU0FWSU5HX1BBUkFNU19OT1RfU1VQUE9SVEVEICAgICAweDM5Ci0jZGVmaW5lIFNF
TkNPREVfRElBR05PU1RJQ19GQUlMVVJFICAgICAgICAgICAgICAweDQwCi0jZGVmaW5lIFNFTkNP
REVfSU5URVJOQUxfVEFSR0VUX0ZBSUxVUkUgICAgICAgICAweDQ0Ci0jZGVmaW5lIFNFTkNPREVf
SU5WQUxJRF9NRVNTQUdFX0VSUk9SICAgICAgICAgICAweDQ5Ci0jZGVmaW5lIFNFTkNPREVfTFVO
X0ZBSUxFRF9TRUxGX0NPTkZJRyAgICAgICAgICAweDRjCi0jZGVmaW5lIFNFTkNPREVfT1ZFUkxB
UFBFRF9DT01NQU5EICAgICAgICAgICAgICAweDRFCisKKyNkZWZpbmUgU0VOQ09ERV9OT19TRU5T
RQkJCTB4MDAKKyNkZWZpbmUgU0VOQ09ERV9FTkRfT0ZfREFUQQkJCTB4MDAKKyNkZWZpbmUgU0VO
Q09ERV9CRUNPTUlOR19SRUFEWQkJCTB4MDQKKyNkZWZpbmUgU0VOQ09ERV9JTklUX0NNRF9SRVFV
SVJFRAkJMHgwNAorI2RlZmluZSBTRU5DT0RFX1BBUkFNX0xJU1RfTEVOR1RIX0VSUk9SCQkweDFB
CisjZGVmaW5lIFNFTkNPREVfSU5WQUxJRF9DT01NQU5ECQkJMHgyMAorI2RlZmluZSBTRU5DT0RF
X0xCQV9PVVRfT0ZfUkFOR0UJCTB4MjEKKyNkZWZpbmUgU0VOQ09ERV9JTlZBTElEX0NEQl9GSUVM
RAkJMHgyNAorI2RlZmluZSBTRU5DT0RFX0xVTl9OT1RfU1VQUE9SVEVECQkweDI1CisjZGVmaW5l
IFNFTkNPREVfSU5WQUxJRF9QQVJBTV9GSUVMRAkJMHgyNgorI2RlZmluZSBTRU5DT0RFX1BBUkFN
X05PVF9TVVBQT1JURUQJCTB4MjYKKyNkZWZpbmUgU0VOQ09ERV9QQVJBTV9WQUxVRV9JTlZBTElE
CQkweDI2CisjZGVmaW5lIFNFTkNPREVfUkVTRVRfT0NDVVJSRUQJCQkweDI5CisjZGVmaW5lIFNF
TkNPREVfTFVOX05PVF9TRUxGX0NPTkZJR1VSRURfWUVUCTB4M0UKKyNkZWZpbmUgU0VOQ09ERV9J
TlFVSVJZX0RBVEFfQ0hBTkdFRAkJMHgzRgorI2RlZmluZSBTRU5DT0RFX1NBVklOR19QQVJBTVNf
Tk9UX1NVUFBPUlRFRAkweDM5CisjZGVmaW5lIFNFTkNPREVfRElBR05PU1RJQ19GQUlMVVJFCQkw
eDQwCisjZGVmaW5lIFNFTkNPREVfSU5URVJOQUxfVEFSR0VUX0ZBSUxVUkUJCTB4NDQKKyNkZWZp
bmUgU0VOQ09ERV9JTlZBTElEX01FU1NBR0VfRVJST1IJCTB4NDkKKyNkZWZpbmUgU0VOQ09ERV9M
VU5fRkFJTEVEX1NFTEZfQ09ORklHCQkweDRjCisjZGVmaW5lIFNFTkNPREVfT1ZFUkxBUFBFRF9D
T01NQU5ECQkweDRFCiAKIC8qCiAgKglBZGRpdGlvbmFsIHNlbnNlIGNvZGVzCiAgKi8KLSAKLSNk
ZWZpbmUgQVNFTkNPREVfTk9fU0VOU0UgICAgICAgICAgICAgICAgICAgICAgIDB4MDAKLSNkZWZp
bmUgQVNFTkNPREVfRU5EX09GX0RBVEEgICAgICAgICAgICAgICAgICAgIDB4MDUKLSNkZWZpbmUg
QVNFTkNPREVfQkVDT01JTkdfUkVBRFkgICAgICAgICAgICAgICAgIDB4MDEKLSNkZWZpbmUgQVNF
TkNPREVfSU5JVF9DTURfUkVRVUlSRUQgICAgICAgICAgICAgIDB4MDIKLSNkZWZpbmUgQVNFTkNP
REVfUEFSQU1fTElTVF9MRU5HVEhfRVJST1IgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVf
SU5WQUxJRF9DT01NQU5EICAgICAgICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfTEJB
X09VVF9PRl9SQU5HRSAgICAgICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfSU5WQUxJ
RF9DREJfRklFTEQgICAgICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfTFVOX05PVF9T
VVBQT1JURUQgICAgICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfSU5WQUxJRF9QQVJB
TV9GSUVMRCAgICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfUEFSQU1fTk9UX1NVUFBP
UlRFRCAgICAgICAgICAgIDB4MDEKLSNkZWZpbmUgQVNFTkNPREVfUEFSQU1fVkFMVUVfSU5WQUxJ
RCAgICAgICAgICAgIDB4MDIKLSNkZWZpbmUgQVNFTkNPREVfUkVTRVRfT0NDVVJSRUQgICAgICAg
ICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfTFVOX05PVF9TRUxGX0NPTkZJR1VSRURf
WUVUICAgIDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfSU5RVUlSWV9EQVRBX0NIQU5HRUQgICAgICAg
ICAgIDB4MDMKLSNkZWZpbmUgQVNFTkNPREVfU0FWSU5HX1BBUkFNU19OT1RfU1VQUE9SVEVEICAg
IDB4MDAKLSNkZWZpbmUgQVNFTkNPREVfRElBR05PU1RJQ19GQUlMVVJFICAgICAgICAgICAgIDB4
ODAKLSNkZWZpbmUgQVNFTkNPREVfSU5URVJOQUxfVEFSR0VUX0ZBSUxVUkUgICAgICAgIDB4MDAK
LSNkZWZpbmUgQVNFTkNPREVfSU5WQUxJRF9NRVNTQUdFX0VSUk9SICAgICAgICAgIDB4MDAKLSNk
ZWZpbmUgQVNFTkNPREVfTFVOX0ZBSUxFRF9TRUxGX0NPTkZJRyAgICAgICAgIDB4MDAKLSNkZWZp
bmUgQVNFTkNPREVfT1ZFUkxBUFBFRF9DT01NQU5EICAgICAgICAgICAgIDB4MDAKKworI2RlZmlu
ZSBBU0VOQ09ERV9OT19TRU5TRQkJCTB4MDAKKyNkZWZpbmUgQVNFTkNPREVfRU5EX09GX0RBVEEJ
CQkweDA1CisjZGVmaW5lIEFTRU5DT0RFX0JFQ09NSU5HX1JFQURZCQkJMHgwMQorI2RlZmluZSBB
U0VOQ09ERV9JTklUX0NNRF9SRVFVSVJFRAkJMHgwMgorI2RlZmluZSBBU0VOQ09ERV9QQVJBTV9M
SVNUX0xFTkdUSF9FUlJPUgkweDAwCisjZGVmaW5lIEFTRU5DT0RFX0lOVkFMSURfQ09NTUFORAkJ
MHgwMAorI2RlZmluZSBBU0VOQ09ERV9MQkFfT1VUX09GX1JBTkdFCQkweDAwCisjZGVmaW5lIEFT
RU5DT0RFX0lOVkFMSURfQ0RCX0ZJRUxECQkweDAwCisjZGVmaW5lIEFTRU5DT0RFX0xVTl9OT1Rf
U1VQUE9SVEVECQkweDAwCisjZGVmaW5lIEFTRU5DT0RFX0lOVkFMSURfUEFSQU1fRklFTEQJCTB4
MDAKKyNkZWZpbmUgQVNFTkNPREVfUEFSQU1fTk9UX1NVUFBPUlRFRAkJMHgwMQorI2RlZmluZSBB
U0VOQ09ERV9QQVJBTV9WQUxVRV9JTlZBTElECQkweDAyCisjZGVmaW5lIEFTRU5DT0RFX1JFU0VU
X09DQ1VSUkVECQkJMHgwMAorI2RlZmluZSBBU0VOQ09ERV9MVU5fTk9UX1NFTEZfQ09ORklHVVJF
RF9ZRVQJMHgwMAorI2RlZmluZSBBU0VOQ09ERV9JTlFVSVJZX0RBVEFfQ0hBTkdFRAkJMHgwMwor
I2RlZmluZSBBU0VOQ09ERV9TQVZJTkdfUEFSQU1TX05PVF9TVVBQT1JURUQJMHgwMAorI2RlZmlu
ZSBBU0VOQ09ERV9ESUFHTk9TVElDX0ZBSUxVUkUJCTB4ODAKKyNkZWZpbmUgQVNFTkNPREVfSU5U
RVJOQUxfVEFSR0VUX0ZBSUxVUkUJMHgwMAorI2RlZmluZSBBU0VOQ09ERV9JTlZBTElEX01FU1NB
R0VfRVJST1IJCTB4MDAKKyNkZWZpbmUgQVNFTkNPREVfTFVOX0ZBSUxFRF9TRUxGX0NPTkZJRwkJ
MHgwMAorI2RlZmluZSBBU0VOQ09ERV9PVkVSTEFQUEVEX0NPTU1BTkQJCTB4MDAKIAogI2RlZmlu
ZSBCWVRFMCh4KSAodW5zaWduZWQgY2hhcikoeCkKICNkZWZpbmUgQllURTEoeCkgKHVuc2lnbmVk
IGNoYXIpKCh4KSA+PiA4KQpAQCAtMTE1LDggKzExNSw4IEBACiAgKi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0qLwogLyogU0NTSSBpbnF1aXJ5IGRhdGEgKi8KIHN0cnVjdCBpbnF1aXJ5X2RhdGEgewotCXU4
IGlucWRfcGR0OwkvKiBQZXJpcGhlcmFsIHF1YWxpZmllciB8IFBlcmlwaGVyYWwgRGV2aWNlIFR5
cGUgICovCi0JdTggaW5xZF9kdHE7CS8qIFJNQiB8IERldmljZSBUeXBlIFF1YWxpZmllciAgKi8K
Kwl1OCBpbnFkX3BkdDsJLyogUGVyaXBoZXJhbCBxdWFsaWZpZXIgfCBQZXJpcGhlcmFsIERldmlj
ZSBUeXBlICovCisJdTggaW5xZF9kdHE7CS8qIFJNQiB8IERldmljZSBUeXBlIFF1YWxpZmllciAq
LwogCXU4IGlucWRfdmVyOwkvKiBJU08gdmVyc2lvbiB8IEVDTUEgdmVyc2lvbiB8IEFOU0ktYXBw
cm92ZWQgdmVyc2lvbiAqLwogCXU4IGlucWRfcmRmOwkvKiBBRU5DIHwgVHJtSU9QIHwgUmVzcG9u
c2UgZGF0YSBmb3JtYXQgKi8KIAl1OCBpbnFkX2xlbjsJLyogQWRkaXRpb25hbCBsZW5ndGggKG4t
NCkgKi8KQEAgLTEzMCw3ICsxMzAsNyBAQAogLyoKICAqICAgICAgICAgICAgICBNIE8gRCBVIEwg
RSAgIEcgTCBPIEIgQSBMIFMKICAqLwotIAorCiBzdGF0aWMgdW5zaWduZWQgbG9uZyBhYWNfYnVp
bGRfc2coc3RydWN0IHNjc2lfY21uZCogc2NzaWNtZCwgc3RydWN0IHNnbWFwKiBzZ21hcCk7CiBz
dGF0aWMgdW5zaWduZWQgbG9uZyBhYWNfYnVpbGRfc2c2NChzdHJ1Y3Qgc2NzaV9jbW5kKiBzY3Np
Y21kLCBzdHJ1Y3Qgc2dtYXA2NCogcHNnKTsKIHN0YXRpYyB1bnNpZ25lZCBsb25nIGFhY19idWls
ZF9zZ3JhdyhzdHJ1Y3Qgc2NzaV9jbW5kKiBzY3NpY21kLCBzdHJ1Y3Qgc2dtYXByYXcqIHBzZyk7
CkBAIC0xNDEsOCArMTQxLDggQEAKIAogLyoKICAqCU5vbiBkYXNkIHNlbGVjdGlvbiBpcyBoYW5k
bGVkIGVudGlyZWx5IGluIGFhY2hiYSBub3cKLSAqLwkKLSAKKyAqLworCiBzdGF0aWMgaW50IG5v
bmRhc2QgPSAtMTsKIHN0YXRpYyBpbnQgYWFjX2NhY2hlID0gMDsKIHN0YXRpYyBpbnQgZGFjbW9k
ZSA9IC0xOwpAQCAtMTk2LDEyICsxOTYsMTIgQEAKIAkJc3RydWN0IGZpYiAqZmlicHRyKSB7CiAJ
c3RydWN0IHNjc2lfZGV2aWNlICpkZXZpY2U7CiAKLQlpZiAodW5saWtlbHkoIXNjc2ljbWQgfHwg
IXNjc2ljbWQtPnNjc2lfZG9uZSApKSB7CisJaWYgKHVubGlrZWx5KCFzY3NpY21kIHx8ICFzY3Np
Y21kLT5zY3NpX2RvbmUpKSB7CiAJCWRwcmludGsoKEtFUk5fV0FSTklORyAiYWFjX3ZhbGlkX2Nv
bnRleHQ6IHNjc2kgY29tbWFuZCBjb3JydXB0XG4iKSk7Ci0gICAgICAgICAgICAgICAgYWFjX2Zp
Yl9jb21wbGV0ZShmaWJwdHIpOwotICAgICAgICAgICAgICAgIGFhY19maWJfZnJlZShmaWJwdHIp
OwotICAgICAgICAgICAgICAgIHJldHVybiAwOwotICAgICAgICB9CisJCWFhY19maWJfY29tcGxl
dGUoZmlicHRyKTsKKwkJYWFjX2ZpYl9mcmVlKGZpYnB0cik7CisJCXJldHVybiAwOworCX0KIAlz
Y3NpY21kLT5TQ3AucGhhc2UgPSBBQUNfT1dORVJfTUlETEVWRUw7CiAJZGV2aWNlID0gc2NzaWNt
ZC0+ZGV2aWNlOwogCWlmICh1bmxpa2VseSghZGV2aWNlIHx8ICFzY3NpX2RldmljZV9vbmxpbmUo
ZGV2aWNlKSkpIHsKQEAgLTI0Myw3ICsyNDMsNyBAQAogCQkJICAgIEZzYU5vcm1hbCwKIAkJCSAg
ICAxLCAxLAogCQkJICAgIE5VTEwsIE5VTEwpOwotCWlmIChzdGF0dXMgPCAwICkgeworCWlmIChz
dGF0dXMgPCAwKSB7CiAJCXByaW50ayhLRVJOX1dBUk5JTkcgImFhY19nZXRfY29uZmlnX3N0YXR1
czogU2VuZEZJQiBmYWlsZWQuXG4iKTsKIAl9IGVsc2UgewogCQlzdHJ1Y3QgYWFjX2dldF9jb25m
aWdfc3RhdHVzX3Jlc3AgKnJlcGx5CkBAIC0yNjcsMTAgKzI2NywxMCBAQAogCQkJc3RydWN0IGFh
Y19jb21taXRfY29uZmlnICogZGluZm87CiAJCQlhYWNfZmliX2luaXQoZmlicHRyKTsKIAkJCWRp
bmZvID0gKHN0cnVjdCBhYWNfY29tbWl0X2NvbmZpZyAqKSBmaWJfZGF0YShmaWJwdHIpOwotCQor
CiAJCQlkaW5mby0+Y29tbWFuZCA9IGNwdV90b19sZTMyKFZNX0NvbnRhaW5lckNvbmZpZyk7CiAJ
CQlkaW5mby0+dHlwZSA9IGNwdV90b19sZTMyKENUX0NPTU1JVF9DT05GSUcpOwotCQorCiAJCQlz
dGF0dXMgPSBhYWNfZmliX3NlbmQoQ29udGFpbmVyQ29tbWFuZCwKIAkJCQkgICAgZmlicHRyLAog
CQkJCSAgICBzaXplb2YgKHN0cnVjdCBhYWNfY29tbWl0X2NvbmZpZyksCkBAIC0yOTYsNyArMjk2
LDcgQEAKIGludCBhYWNfZ2V0X2NvbnRhaW5lcnMoc3RydWN0IGFhY19kZXYgKmRldikKIHsKIAlz
dHJ1Y3QgZnNhX2Rldl9pbmZvICpmc2FfZGV2X3B0cjsKLQl1MzIgaW5kZXg7IAorCXUzMiBpbmRl
eDsKIAlpbnQgc3RhdHVzID0gMDsKIAlzdHJ1Y3QgZmliICogZmlicHRyOwogCXN0cnVjdCBhYWNf
Z2V0X2NvbnRhaW5lcl9jb3VudCAqZGluZm87CkBAIC0zOTksNyArMzk5LDcgQEAKIAkJCWRvIHsK
IAkJCQkqZHArKyA9ICgqc3ApID8gKnNwKysgOiAnICc7CiAJCQl9IHdoaWxlICgtLWNvdW50ID4g
MCk7Ci0JCQlhYWNfaW50ZXJuYWxfdHJhbnNmZXIoc2NzaWNtZCwgZCwgCisJCQlhYWNfaW50ZXJu
YWxfdHJhbnNmZXIoc2NzaWNtZCwgZCwKIAkJCSAgb2Zmc2V0b2Yoc3RydWN0IGlucXVpcnlfZGF0
YSwgaW5xZF9waWQpLCBzaXplb2YoZCkpOwogCQl9CiAJfQpAQCAtNDM1LDEzICs0MzUsMTMgQEAK
IAlkaW5mby0+Y291bnQgPSBjcHVfdG9fbGUzMihzaXplb2YoKChzdHJ1Y3QgYWFjX2dldF9uYW1l
X3Jlc3AgKilOVUxMKS0+ZGF0YSkpOwogCiAJc3RhdHVzID0gYWFjX2ZpYl9zZW5kKENvbnRhaW5l
ckNvbW1hbmQsCi0JCSAgY21kX2ZpYmNvbnRleHQsIAorCQkgIGNtZF9maWJjb250ZXh0LAogCQkg
IHNpemVvZiAoc3RydWN0IGFhY19nZXRfbmFtZSksCi0JCSAgRnNhTm9ybWFsLCAKLQkJICAwLCAx
LCAKLQkJICAoZmliX2NhbGxiYWNrKSBnZXRfY29udGFpbmVyX25hbWVfY2FsbGJhY2ssIAorCQkg
IEZzYU5vcm1hbCwKKwkJICAwLCAxLAorCQkgIChmaWJfY2FsbGJhY2spZ2V0X2NvbnRhaW5lcl9u
YW1lX2NhbGxiYWNrLAogCQkgICh2b2lkICopIHNjc2ljbWQpOwotCQorCiAJLyoKIAkgKglDaGVj
ayB0aGF0IHRoZSBjb21tYW5kIHF1ZXVlZCB0byB0aGUgY29udHJvbGxlcgogCSAqLwpAQCAtNDQ5
LDcgKzQ0OSw3IEBACiAJCXNjc2ljbWQtPlNDcC5waGFzZSA9IEFBQ19PV05FUl9GSVJNV0FSRTsK
IAkJcmV0dXJuIDA7CiAJfQotCQkKKwogCXByaW50ayhLRVJOX1dBUk5JTkcgImFhY19nZXRfY29u
dGFpbmVyX25hbWU6IGFhY19maWJfc2VuZCBmYWlsZWQgd2l0aCBzdGF0dXM6ICVkLlxuIiwgc3Rh
dHVzKTsKIAlhYWNfZmliX2NvbXBsZXRlKGNtZF9maWJjb250ZXh0KTsKIAlhYWNfZmliX2ZyZWUo
Y21kX2ZpYmNvbnRleHQpOwpAQCAtNjU2LDM5ICs2NTYsMzkgQEAKICAqCUBhOglzdHJpbmcgdG8g
Y29weSBmcm9tCiAgKglAYjoJc3RyaW5nIHRvIGNvcHkgdG8KICAqCi0gKiAJQ29weSBhIFN0cmlu
ZyBmcm9tIG9uZSBsb2NhdGlvbiB0byBhbm90aGVyCisgKglDb3B5IGEgU3RyaW5nIGZyb20gb25l
IGxvY2F0aW9uIHRvIGFub3RoZXIKICAqCXdpdGhvdXQgY29weWluZyBcMAogICovCiAKIHN0YXRp
YyB2b2lkIGlucXN0cmNweShjaGFyICphLCBjaGFyICpiKQogewogCi0Jd2hpbGUoKmEgIT0gKGNo
YXIpMCkgCisJd2hpbGUgKCphICE9IChjaGFyKTApCiAJCSpiKysgPSAqYSsrOwogfQogCiBzdGF0
aWMgY2hhciAqY29udGFpbmVyX3R5cGVzW10gPSB7Ci0gICAgICAgICJOb25lIiwKLSAgICAgICAg
IlZvbHVtZSIsCi0gICAgICAgICJNaXJyb3IiLAotICAgICAgICAiU3RyaXBlIiwKLSAgICAgICAg
IlJBSUQ1IiwKLSAgICAgICAgIlNTUlciLAotICAgICAgICAiU1NSTyIsCi0gICAgICAgICJNb3Jw
aCIsCi0gICAgICAgICJMZWdhY3kiLAotICAgICAgICAiUkFJRDQiLAotICAgICAgICAiUkFJRDEw
IiwgICAgICAgICAgICAgCi0gICAgICAgICJSQUlEMDAiLCAgICAgICAgICAgICAKLSAgICAgICAg
IlYtTUlSUk9SUyIsICAgICAgICAgIAotICAgICAgICAiUFNFVURPIFI0IiwgICAgICAgICAgCisJ
Ik5vbmUiLAorCSJWb2x1bWUiLAorCSJNaXJyb3IiLAorCSJTdHJpcGUiLAorCSJSQUlENSIsCisJ
IlNTUlciLAorCSJTU1JPIiwKKwkiTW9ycGgiLAorCSJMZWdhY3kiLAorCSJSQUlENCIsCisJIlJB
SUQxMCIsCisJIlJBSUQwMCIsCisJIlYtTUlSUk9SUyIsCisJIlBTRVVETyBSNCIsCiAJIlJBSUQ1
MCIsCiAJIlJBSUQ1RCIsCiAJIlJBSUQ1RDAiLAogCSJSQUlEMUUiLAogCSJSQUlENiIsCiAJIlJB
SUQ2MCIsCi0gICAgICAgICJVbmtub3duIgorCSJVbmtub3duIgogfTsKIAogY2hhciAqIGdldF9j
b250YWluZXJfdHlwZSh1bnNpZ25lZCB0aW5kZXgpCkBAIC0xMjMwLDExICsxMjMwLDExIEBACiAJ
bWVtc2V0KGluZm8sMCxzaXplb2YoKmluZm8pKTsKIAogCXJjb2RlID0gYWFjX2ZpYl9zZW5kKFJl
cXVlc3RBZGFwdGVySW5mbywKLQkJCSBmaWJwdHIsIAorCQkJIGZpYnB0ciwKIAkJCSBzaXplb2Yo
KmluZm8pLAotCQkJIEZzYU5vcm1hbCwgCisJCQkgRnNhTm9ybWFsLAogCQkJIC0xLCAxLCAvKiBG
aXJzdCBgaW50ZXJydXB0JyBjb21tYW5kIHVzZXMgc3BlY2lhbCB3YWl0ICovCi0JCQkgTlVMTCwg
CisJCQkgTlVMTCwKIAkJCSBOVUxMKTsKIAogCWlmIChyY29kZSA8IDApIHsKQEAgLTEyNjYsOCAr
MTI2Niw4IEBACiAJfQogCiAKLQkvKiAKLQkgKiBHZXRCdXNJbmZvIAorCS8qCisJICogR2V0QnVz
SW5mbwogCSAqLwogCiAJYWFjX2ZpYl9pbml0KGZpYnB0cik7CkBAIC0xMzAxLDcgKzEzMDEsNyBA
QAogCQljaGFyIGJ1ZmZlclsxNl07CiAJCXRtcCA9IGxlMzJfdG9fY3B1KGRldi0+YWRhcHRlcl9p
bmZvLmtlcm5lbHJldik7CiAJCXByaW50ayhLRVJOX0lORk8gIiVzJWQ6IGtlcm5lbCAlZC4lZC0l
ZFslZF0gJS4qc1xuIiwKLQkJCWRldi0+bmFtZSwgCisJCQlkZXYtPm5hbWUsCiAJCQlkZXYtPmlk
LAogCQkJdG1wPj4yNCwKIAkJCSh0bXA+PjE2KSYweGZmLApAQCAtMTM2Myw3ICsxMzYzLDcgQEAK
IAlpZiAoZGV2LT5yYWlkX3Njc2lfbW9kZSAhPSAwKQogCQlwcmludGsoS0VSTl9JTkZPICIlcyVk
OiBST01CIFJBSUQvU0NTSSBtb2RlIGVuYWJsZWRcbiIsCiAJCQkJZGV2LT5uYW1lLCBkZXYtPmlk
KTsKLQkJCisKIAlpZiAobm9uZGFzZCAhPSAtMSkKIAkJZGV2LT5ub25kYXNkX3N1cHBvcnQgPSAo
bm9uZGFzZCE9MCk7CiAJaWYoZGV2LT5ub25kYXNkX3N1cHBvcnQgIT0gMCkgewpAQCAtMTM5NSw3
ICsxMzk1LDcgQEAKIAkJCXJjb2RlID0gLUVOT01FTTsKIAkJfQogCX0KLQkvKiAKKwkvKgogCSAq
IERlYWwgd2l0aCBjb25maWd1cmluZyBmb3IgdGhlIGluZGl2aWR1YWxpemVkIGxpbWl0cyBvZiBl
YWNoIHBhY2tldAogCSAqIGludGVyZmFjZS4KIAkgKi8KQEAgLTE0MTksOCArMTQxOSw4IEBACiAJ
CWlmIChkZXYtPmRhY19zdXBwb3J0KSB7CiAJCQlkZXYtPmFfb3BzLmFkYXB0ZXJfcmVhZCA9IGFh
Y19yZWFkX2Jsb2NrNjQ7CiAJCQlkZXYtPmFfb3BzLmFkYXB0ZXJfd3JpdGUgPSBhYWNfd3JpdGVf
YmxvY2s2NDsKLQkJCS8qIAotCQkJICogMzggc2NhdHRlciBnYXRoZXIgZWxlbWVudHMgCisJCQkv
KgorCQkJICogMzggc2NhdHRlciBnYXRoZXIgZWxlbWVudHMKIAkJCSAqLwogCQkJZGV2LT5zY3Np
X2hvc3RfcHRyLT5zZ190YWJsZXNpemUgPQogCQkJCShkZXYtPm1heF9maWJfc2l6ZSAtCkBAIC0x
NTQ5LDcgKzE1NDksNyBAQAogCWNhc2UgUkVBRF82OgogCQlkcHJpbnRrKChLRVJOX0RFQlVHICJh
YWNoYmE6IHJlY2VpdmVkIGEgcmVhZCg2KSBjb21tYW5kIG9uIGlkICVkLlxuIiwgc2NtZF9pZChz
Y3NpY21kKSkpOwogCi0JCWxiYSA9ICgoc2NzaWNtZC0+Y21uZFsxXSAmIDB4MUYpIDw8IDE2KSB8
IAorCQlsYmEgPSAoKHNjc2ljbWQtPmNtbmRbMV0gJiAweDFGKSA8PCAxNikgfAogCQkJKHNjc2lj
bWQtPmNtbmRbMl0gPDwgOCkgfCBzY3NpY21kLT5jbW5kWzNdOwogCQljb3VudCA9IHNjc2ljbWQt
PmNtbmRbNF07CiAKQEAgLTE1NTksMzIgKzE1NTksMzIgQEAKIAljYXNlIFJFQURfMTY6CiAJCWRw
cmludGsoKEtFUk5fREVCVUcgImFhY2hiYTogcmVjZWl2ZWQgYSByZWFkKDE2KSBjb21tYW5kIG9u
IGlkICVkLlxuIiwgc2NtZF9pZChzY3NpY21kKSkpOwogCi0JCWxiYSA9IAkoKHU2NClzY3NpY21k
LT5jbW5kWzJdIDw8IDU2KSB8Ci0JCSAJKCh1NjQpc2NzaWNtZC0+Y21uZFszXSA8PCA0OCkgfAor
CQlsYmEgPQkoKHU2NClzY3NpY21kLT5jbW5kWzJdIDw8IDU2KSB8CisJCQkoKHU2NClzY3NpY21k
LT5jbW5kWzNdIDw8IDQ4KSB8CiAJCQkoKHU2NClzY3NpY21kLT5jbW5kWzRdIDw8IDQwKSB8CiAJ
CQkoKHU2NClzY3NpY21kLT5jbW5kWzVdIDw8IDMyKSB8Ci0JCQkoKHU2NClzY3NpY21kLT5jbW5k
WzZdIDw8IDI0KSB8IAorCQkJKCh1NjQpc2NzaWNtZC0+Y21uZFs2XSA8PCAyNCkgfAogCQkJKHNj
c2ljbWQtPmNtbmRbN10gPDwgMTYpIHwKIAkJCShzY3NpY21kLT5jbW5kWzhdIDw8IDgpIHwgc2Nz
aWNtZC0+Y21uZFs5XTsKLQkJY291bnQgPSAoc2NzaWNtZC0+Y21uZFsxMF0gPDwgMjQpIHwgCisJ
CWNvdW50ID0gKHNjc2ljbWQtPmNtbmRbMTBdIDw8IDI0KSB8CiAJCQkoc2NzaWNtZC0+Y21uZFsx
MV0gPDwgMTYpIHwKIAkJCShzY3NpY21kLT5jbW5kWzEyXSA8PCA4KSB8IHNjc2ljbWQtPmNtbmRb
MTNdOwogCQlicmVhazsKIAljYXNlIFJFQURfMTI6CiAJCWRwcmludGsoKEtFUk5fREVCVUcgImFh
Y2hiYTogcmVjZWl2ZWQgYSByZWFkKDEyKSBjb21tYW5kIG9uIGlkICVkLlxuIiwgc2NtZF9pZChz
Y3NpY21kKSkpOwogCi0JCWxiYSA9ICgodTY0KXNjc2ljbWQtPmNtbmRbMl0gPDwgMjQpIHwgCisJ
CWxiYSA9ICgodTY0KXNjc2ljbWQtPmNtbmRbMl0gPDwgMjQpIHwKIAkJCShzY3NpY21kLT5jbW5k
WzNdIDw8IDE2KSB8Ci0JCSAgICAJKHNjc2ljbWQtPmNtbmRbNF0gPDwgOCkgfCBzY3NpY21kLT5j
bW5kWzVdOwotCQljb3VudCA9IChzY3NpY21kLT5jbW5kWzZdIDw8IDI0KSB8IAorCQkJKHNjc2lj
bWQtPmNtbmRbNF0gPDwgOCkgfCBzY3NpY21kLT5jbW5kWzVdOworCQljb3VudCA9IChzY3NpY21k
LT5jbW5kWzZdIDw8IDI0KSB8CiAJCQkoc2NzaWNtZC0+Y21uZFs3XSA8PCAxNikgfAotCQkgICAg
ICAJKHNjc2ljbWQtPmNtbmRbOF0gPDwgOCkgfCBzY3NpY21kLT5jbW5kWzldOworCQkJKHNjc2lj
bWQtPmNtbmRbOF0gPDwgOCkgfCBzY3NpY21kLT5jbW5kWzldOwogCQlicmVhazsKIAlkZWZhdWx0
OgogCQlkcHJpbnRrKChLRVJOX0RFQlVHICJhYWNoYmE6IHJlY2VpdmVkIGEgcmVhZCgxMCkgY29t
bWFuZCBvbiBpZCAlZC5cbiIsIHNjbWRfaWQoc2NzaWNtZCkpKTsKIAotCQlsYmEgPSAoKHU2NClz
Y3NpY21kLT5jbW5kWzJdIDw8IDI0KSB8IAotCQkJKHNjc2ljbWQtPmNtbmRbM10gPDwgMTYpIHwg
CisJCWxiYSA9ICgodTY0KXNjc2ljbWQtPmNtbmRbMl0gPDwgMjQpIHwKKwkJCShzY3NpY21kLT5j
bW5kWzNdIDw8IDE2KSB8CiAJCQkoc2NzaWNtZC0+Y21uZFs0XSA8PCA4KSB8IHNjc2ljbWQtPmNt
bmRbNV07CiAJCWNvdW50ID0gKHNjc2ljbWQtPmNtbmRbN10gPDwgOCkgfCBzY3NpY21kLT5jbW5k
WzhdOwogCQlicmVhazsKQEAgLTE2MDksNyArMTYwOSw3IEBACiAJCXNjc2ljbWQtPlNDcC5waGFz
ZSA9IEFBQ19PV05FUl9GSVJNV0FSRTsKIAkJcmV0dXJuIDA7CiAJfQotCQkKKwogCXByaW50ayhL
RVJOX1dBUk5JTkcgImFhY19yZWFkOiBhYWNfZmliX3NlbmQgZmFpbGVkIHdpdGggc3RhdHVzOiAl
ZC5cbiIsIHN0YXR1cyk7CiAJLyoKIAkgKglGb3Igc29tZSByZWFzb24sIHRoZSBGaWIgZGlkbid0
IHF1ZXVlLCByZXR1cm4gUVVFVUVfRlVMTApAQCAtMTY0NCwxMSArMTY0NCwxMSBAQAogCX0gZWxz
ZSBpZiAoc2NzaWNtZC0+Y21uZFswXSA9PSBXUklURV8xNikgeyAvKiAxNiBieXRlIGNvbW1hbmQg
Ki8KIAkJZHByaW50aygoS0VSTl9ERUJVRyAiYWFjaGJhOiByZWNlaXZlZCBhIHdyaXRlKDE2KSBj
b21tYW5kIG9uIGlkICVkLlxuIiwgc2NtZF9pZChzY3NpY21kKSkpOwogCi0JCWxiYSA9IAkoKHU2
NClzY3NpY21kLT5jbW5kWzJdIDw8IDU2KSB8CisJCWxiYSA9CSgodTY0KXNjc2ljbWQtPmNtbmRb
Ml0gPDwgNTYpIHwKIAkJCSgodTY0KXNjc2ljbWQtPmNtbmRbM10gPDwgNDgpIHwKIAkJCSgodTY0
KXNjc2ljbWQtPmNtbmRbNF0gPDwgNDApIHwKIAkJCSgodTY0KXNjc2ljbWQtPmNtbmRbNV0gPDwg
MzIpIHwKLQkJCSgodTY0KXNjc2ljbWQtPmNtbmRbNl0gPDwgMjQpIHwgCisJCQkoKHU2NClzY3Np
Y21kLT5jbW5kWzZdIDw8IDI0KSB8CiAJCQkoc2NzaWNtZC0+Y21uZFs3XSA8PCAxNikgfAogCQkJ
KHNjc2ljbWQtPmNtbmRbOF0gPDwgOCkgfCBzY3NpY21kLT5jbW5kWzldOwogCQljb3VudCA9IChz
Y3NpY21kLT5jbW5kWzEwXSA8PCAyNCkgfCAoc2NzaWNtZC0+Y21uZFsxMV0gPDwgMTYpIHwKQEAg
LTE4NzUsMTQgKzE4NzUsMTQgQEAKICAqCUVtdWxhdGUgYSBTQ1NJIGNvbW1hbmQgYW5kIHF1ZXVl
IHRoZSByZXF1aXJlZCByZXF1ZXN0IGZvciB0aGUKICAqCWFhY3JhaWQgZmlybXdhcmUuCiAgKi8K
LSAKKwogaW50IGFhY19zY3NpX2NtZChzdHJ1Y3Qgc2NzaV9jbW5kICogc2NzaWNtZCkKIHsKIAl1
MzIgY2lkOwogCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBzY3NpY21kLT5kZXZpY2UtPmhvc3Q7
CiAJc3RydWN0IGFhY19kZXYgKmRldiA9IChzdHJ1Y3QgYWFjX2RldiAqKWhvc3QtPmhvc3RkYXRh
OwogCXN0cnVjdCBmc2FfZGV2X2luZm8gKmZzYV9kZXZfcHRyID0gZGV2LT5mc2FfZGV2OwotCQor
CiAJaWYgKGZzYV9kZXZfcHRyID09IE5VTEwpCiAJCXJldHVybiAtMTsKIAkvKgpAQCAtMTkzOCw3
ICsxOTM4LDcgQEAKIAkgKiBlbHNlIENvbW1hbmQgZm9yIHRoZSBjb250cm9sbGVyIGl0c2VsZgog
CSAqLwogCWVsc2UgaWYgKChzY3NpY21kLT5jbW5kWzBdICE9IElOUVVJUlkpICYmCS8qIG9ubHkg
SU5RVUlSWSAmIFRVUiBjbW5kIHN1cHBvcnRlZCBmb3IgY29udHJvbGxlciAqLwotCQkoc2NzaWNt
ZC0+Y21uZFswXSAhPSBURVNUX1VOSVRfUkVBRFkpKSAKKwkJKHNjc2ljbWQtPmNtbmRbMF0gIT0g
VEVTVF9VTklUX1JFQURZKSkKIAl7CiAJCWRwcmludGsoKEtFUk5fV0FSTklORyAiT25seSBJTlFV
SVJZICYgVFVSIGNvbW1hbmQgc3VwcG9ydGVkIGZvciBjb250cm9sbGVyLCByY3ZkID0gMHgleC5c
biIsIHNjc2ljbWQtPmNtbmRbMF0pKTsKIAkJc2NzaWNtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2
IHwgQ09NTUFORF9DT01QTEVURSA8PCA4IHwgU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OOwpAQCAt
MTk2Myw3ICsxOTYzLDcgQEAKIAkJZHByaW50aygoS0VSTl9ERUJVRyAiSU5RVUlSWSBjb21tYW5k
LCBJRDogJWQuXG4iLCBjaWQpKTsKIAkJbWVtc2V0KCZpbnFfZGF0YSwgMCwgc2l6ZW9mIChzdHJ1
Y3QgaW5xdWlyeV9kYXRhKSk7CiAKLQkJaWYgKHNjc2ljbWQtPmNtbmRbMV0gJiAweDEgKSB7CisJ
CWlmIChzY3NpY21kLT5jbW5kWzFdICYgMHgxKSB7CiAJCQljaGFyICphcnIgPSAoY2hhciAqKSZp
bnFfZGF0YTsKIAogCQkJLyogRVZQRCBiaXQgc2V0ICovCkBAIC0yMjA0LDcgKzIyMDQsNyBAQAog
CQlyZXR1cm4gMDsKIAl9CiAKLQlzd2l0Y2ggKHNjc2ljbWQtPmNtbmRbMF0pIAorCXN3aXRjaCAo
c2NzaWNtZC0+Y21uZFswXSkKIAl7CiAJCWNhc2UgUkVBRF82OgogCQljYXNlIFJFQURfMTA6CkBA
IC0yMjE3LDExICsyMjE3LDExIEBACiAJCQkgKgljb3JyZXNwb25kcyB0byBhIGNvbnRhaW5lci4g
TmVlZGVkIHRvIGNvbnZlcnQKIAkJCSAqCWNvbnRhaW5lcnMgdG8gL2Rldi9zZCBkZXZpY2UgbmFt
ZXMKIAkJCSAqLwotCQkJIAorCiAJCQlpZiAoc2NzaWNtZC0+cmVxdWVzdC0+cnFfZGlzaykKIAkJ
CQlzdHJsY3B5KGZzYV9kZXZfcHRyW2NpZF0uZGV2bmFtZSwKIAkJCQlzY3NpY21kLT5yZXF1ZXN0
LT5ycV9kaXNrLT5kaXNrX25hbWUsCi0JCQkgIAltaW4oc2l6ZW9mKGZzYV9kZXZfcHRyW2NpZF0u
ZGV2bmFtZSksCisJCQkJbWluKHNpemVvZihmc2FfZGV2X3B0cltjaWRdLmRldm5hbWUpLAogCQkJ
CXNpemVvZihzY3NpY21kLT5yZXF1ZXN0LT5ycV9kaXNrLT5kaXNrX25hbWUpICsgMSkpOwogCiAJ
CQlyZXR1cm4gYWFjX3JlYWQoc2NzaWNtZCk7CkBAIC0yMjc1LDcgKzIyNzUsNyBAQAogCQlyZXR1
cm4gLUVGQVVMVDsKIAlpZiAocWQuY251bSA9PSAtMSkKIAkJcWQuY251bSA9IHFkLmlkOwotCWVs
c2UgaWYgKChxZC5idXMgPT0gLTEpICYmIChxZC5pZCA9PSAtMSkgJiYgKHFkLmx1biA9PSAtMSkp
IAorCWVsc2UgaWYgKChxZC5idXMgPT0gLTEpICYmIChxZC5pZCA9PSAtMSkgJiYgKHFkLmx1biA9
PSAtMSkpCiAJewogCQlpZiAocWQuY251bSA8IDAgfHwgcWQuY251bSA+PSBkZXYtPm1heGltdW1f
bnVtX2NvbnRhaW5lcnMpCiAJCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTI0MDIsNyArMjQwMiw3IEBA
CiAKIAlzY3NpY21kLT5zZW5zZV9idWZmZXJbMF0gPSAnXDAnOyAgLyogSW5pdGlhbGl6ZSBzZW5z
ZSB2YWxpZCBmbGFnIHRvIGZhbHNlICovCiAJLyoKLQkgKglDYWxjdWxhdGUgcmVzaWQgZm9yIHNn
IAorCSAqCUNhbGN1bGF0ZSByZXNpZCBmb3Igc2cKIAkgKi8KIAogCXNjc2lfc2V0X3Jlc2lkKHNj
c2ljbWQsIHNjc2lfYnVmZmxlbihzY3NpY21kKQpAQCAtMjQ0Miw3ICsyNDQyLDcgQEAKIAkJY2Fz
ZSAgV1JJVEVfMTI6CiAJCWNhc2UgIFJFQURfMTY6CiAJCWNhc2UgIFdSSVRFXzE2OgotCQkJaWYo
bGUzMl90b19jcHUoc3JicmVwbHktPmRhdGFfeGZlcl9sZW5ndGgpIDwgc2NzaWNtZC0+dW5kZXJm
bG93ICkgeworCQkJaWYobGUzMl90b19jcHUoc3JicmVwbHktPmRhdGFfeGZlcl9sZW5ndGgpIDwg
c2NzaWNtZC0+dW5kZXJmbG93KSB7CiAJCQkJcHJpbnRrKEtFUk5fV0FSTklORyJhYWNyYWlkOiBT
Q1NJIENNRCB1bmRlcmZsb3dcbiIpOwogCQkJfSBlbHNlIHsKIAkJCQlwcmludGsoS0VSTl9XQVJO
SU5HImFhY3JhaWQ6IFNDU0kgQ01EIERhdGEgT3ZlcnJ1blxuIik7CkBAIC0yNTExLDE0ICsyNTEx
LDE0IEBACiAJCXByaW50aygiYWFjcmFpZDogU1JCIEVSUk9SKCV1KSAlcyBzY3NpIGNtZCAweCV4
IC0gc2NzaSBzdGF0dXMgMHgleFxuIiwKIAkJCWxlMzJfdG9fY3B1KHNyYnJlcGx5LT5zcmJfc3Rh
dHVzKSAmIDB4M0YsCiAJCQlhYWNfZ2V0X3N0YXR1c19zdHJpbmcoCi0JCQkJbGUzMl90b19jcHUo
c3JicmVwbHktPnNyYl9zdGF0dXMpICYgMHgzRiksIAotCQkJc2NzaWNtZC0+Y21uZFswXSwgCisJ
CQkJbGUzMl90b19jcHUoc3JicmVwbHktPnNyYl9zdGF0dXMpICYgMHgzRiksCisJCQlzY3NpY21k
LT5jbW5kWzBdLAogCQkJbGUzMl90b19jcHUoc3JicmVwbHktPnNjc2lfc3RhdHVzKSk7CiAjZW5k
aWYKIAkJc2NzaWNtZC0+cmVzdWx0ID0gRElEX0VSUk9SIDw8IDE2IHwgQ09NTUFORF9DT01QTEVU
RSA8PCA4OwogCQlicmVhazsKIAl9Ci0JaWYgKGxlMzJfdG9fY3B1KHNyYnJlcGx5LT5zY3NpX3N0
YXR1cykgPT0gMHgwMiApeyAgLy8gQ2hlY2sgQ29uZGl0aW9uCisJaWYgKGxlMzJfdG9fY3B1KHNy
YnJlcGx5LT5zY3NpX3N0YXR1cykgPT0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OKSB7CiAJCWlu
dCBsZW47CiAJCXNjc2ljbWQtPnJlc3VsdCB8PSBTQU1fU1RBVF9DSEVDS19DT05ESVRJT047CiAJ
CWxlbiA9IG1pbl90KHUzMiwgbGUzMl90b19jcHUoc3JicmVwbHktPnNlbnNlX2RhdGFfc2l6ZSks
CkBAIC0yNTI4LDcgKzI1MjgsNiBAQAogCQkJCQlsZTMyX3RvX2NwdShzcmJyZXBseS0+c3RhdHVz
KSwgbGVuKTsKICNlbmRpZgogCQltZW1jcHkoc2NzaWNtZC0+c2Vuc2VfYnVmZmVyLCBzcmJyZXBs
eS0+c2Vuc2VfZGF0YSwgbGVuKTsKLQkJCiAJfQogCS8qCiAJICogT1IgaW4gdGhlIHNjc2kgc3Rh
dHVzIChhbHJlYWR5IHNoaWZ0ZWQgdXAgYSBiaXQpCkBAIC0yNTQ1LDcgKzI1NDQsNyBAQAogICog
YWFjX3NlbmRfc2NiX2ZpYgogICogQHNjc2ljbWQ6IHRoZSBzY3NpIGNvbW1hbmQgYmxvY2sKICAq
Ci0gKiBUaGlzIHJvdXRpbmUgd2lsbCBmb3JtIGEgRklCIGFuZCBmaWxsIGluIHRoZSBhYWNfc3Ji
IGZyb20gdGhlIAorICogVGhpcyByb3V0aW5lIHdpbGwgZm9ybSBhIEZJQiBhbmQgZmlsbCBpbiB0
aGUgYWFjX3NyYiBmcm9tIHRoZQogICogc2NzaWNtZCBwYXNzZWQgaW4uCiAgKi8KIApAQCAtMjc1
OSw3ICsyNzU4LDcgQEAKIAl7IFNSQl9TVEFUVVNfRVJST1JfUkVDT1ZFUlksCSJFcnJvciBSZWNv
dmVyeSJ9LAogCXsgU1JCX1NUQVRVU19OT1RfU1RBUlRFRCwJIk5vdCBTdGFydGVkIn0sCiAJeyBT
UkJfU1RBVFVTX05PVF9JTl9VU0UsCSJOb3QgSW4gVXNlIn0sCi0gICAgCXsgU1JCX1NUQVRVU19G
T1JDRV9BQk9SVCwJIkZvcmNlIEFib3J0In0sCisJeyBTUkJfU1RBVFVTX0ZPUkNFX0FCT1JULAki
Rm9yY2UgQWJvcnQifSwKIAl7IFNSQl9TVEFUVVNfRE9NQUlOX1ZBTElEQVRJT05fRkFJTCwiRG9t
YWluIFZhbGlkYXRpb24gRmFpbHVyZSJ9LAogCXsgMHhmZiwJCQkJIlVua25vd24gRXJyb3IifQog
fTsKZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmggYi9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9hYWNyYWlkLmgKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5o
CTIwMDgtMDEtMTYgMDk6Mjg6MDguMjQ0ODM2MTgzIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY3JhaWQuaAkyMDA4LTAxLTE2IDEwOjAwOjUxLjg5MzYxNjYyOSAtMDUwMApAQCAt
MSw0ICsxLDQgQEAKLSNpZiAoIWRlZmluZWQoZHByaW50aykpCisjaWZuZGVmIGRwcmludGsKICMg
ZGVmaW5lIGRwcmludGsoeCkKICNlbmRpZgogLyogZWc6IGlmIChuYmxhbmsoZHByaW50ayh4KSkp
ICovCkBAIC01MCw5ICs1MCw5IEBACiAvKgogICoJRmlybXdhcmUgY29uc3RhbnRzCiAgKi8KLSAK
KwogI2RlZmluZQkJQ1RfTk9ORQkJCTAKLSNkZWZpbmUgCUNUX09LICAgICAgICAJCTIxOAorI2Rl
ZmluZQkJQ1RfT0sJCQkyMTgKICNkZWZpbmUJCUZUX0ZJTEVTWVMJOAkvKiBBREFQVEVDJ3MgIkZT
QSIodG0pIGZpbGVzeXN0ZW0gKi8KICNkZWZpbmUJCUZUX0RSSVZFCTkJLyogcGh5c2ljYWwgZGlz
ayAtIGFkZHJlc3NhYmxlIGluIHNjc2kgYnkgYnVzL2lkL2x1biAqLwogCkBAIC0xMDcsMTIgKzEw
NywxMiBAQAogCiBzdHJ1Y3Qgc2dtYXAgewogCV9fbGUzMgkJY291bnQ7Ci0Jc3RydWN0IHNnZW50
cnkJc2dbMV07IAorCXN0cnVjdCBzZ2VudHJ5CXNnWzFdOwogfTsKIAogc3RydWN0IHVzZXJfc2dt
YXAgewogCXUzMgkJY291bnQ7Ci0Jc3RydWN0IHVzZXJfc2dlbnRyeQlzZ1sxXTsgCisJc3RydWN0
IHVzZXJfc2dlbnRyeQlzZ1sxXTsKIH07CiAKIHN0cnVjdCBzZ21hcDY0IHsKQEAgLTEzNywxOCAr
MTM3LDE4IEBACiAKIHN0cnVjdCBjcmVhdGlvbl9pbmZvCiB7Ci0JdTggCQlidWlsZG51bTsJCS8q
IGUuZy4sIDU4OCAqLwotCXU4IAkJdXNlYzsJCQkvKiBlLmcuLCA1ODggKi8KLQl1OAkgCXZpYTsJ
CQkvKiBlLmcuLCAxID0gRlNVLAotCQkJCQkJICogCSAyID0gQVBJCisJdTgJCWJ1aWxkbnVtOwkJ
LyogZS5nLiwgNTg4ICovCisJdTgJCXVzZWM7CQkJLyogZS5nLiwgNTg4ICovCisJdTgJCXZpYTsJ
CQkvKiBlLmcuLCAxID0gRlNVLAorCQkJCQkJICoJIDIgPSBBUEkKIAkJCQkJCSAqLwotCXU4CSAJ
eWVhcjsJCSAJLyogZS5nLiwgMTk5NyA9IDk3ICovCisJdTgJCXllYXI7CQkJLyogZS5nLiwgMTk5
NyA9IDk3ICovCiAJX19sZTMyCQlkYXRlOwkJCS8qCi0JCQkJCQkgKiB1bnNpZ25lZCAJTW9udGgJ
CTo0OwkvLyAxIC0gMTIKLQkJCQkJCSAqIHVuc2lnbmVkIAlEYXkJCTo2OwkvLyAxIC0gMzIKLQkJ
CQkJCSAqIHVuc2lnbmVkIAlIb3VyCQk6NjsJLy8gMCAtIDIzCi0JCQkJCQkgKiB1bnNpZ25lZCAJ
TWludXRlCQk6NjsJLy8gMCAtIDYwCi0JCQkJCQkgKiB1bnNpZ25lZCAJU2Vjb25kCQk6NjsJLy8g
MCAtIDYwCisJCQkJCQkgKiB1bnNpZ25lZAlNb250aAkJOjQ7CS8vIDEgLSAxMgorCQkJCQkJICog
dW5zaWduZWQJRGF5CQk6NjsJLy8gMSAtIDMyCisJCQkJCQkgKiB1bnNpZ25lZAlIb3VyCQk6NjsJ
Ly8gMCAtIDIzCisJCQkJCQkgKiB1bnNpZ25lZAlNaW51dGUJCTo2OwkvLyAwIC0gNjAKKwkJCQkJ
CSAqIHVuc2lnbmVkCVNlY29uZAkJOjY7CS8vIDAgLSA2MAogCQkJCQkJICovCiAJX19sZTMyCQlz
ZXJpYWxbMl07CQkJLyogZS5nLiwgMHgxREVBREIwQkZBRkFGMDAxICovCiB9OwpAQCAtMTg0LDcg
KzE4NCw3IEBACiAvKgogICoJU2V0IHRoZSBxdWV1ZXMgb24gYSAxNiBieXRlIGFsaWdubWVudAog
ICovCi0gCisKICNkZWZpbmUgUVVFVUVfQUxJR05NRU5UCQkxNgogCiAvKgpAQCAtMjAzLDkgKzIw
Myw5IEBACiAgKglUaGUgYWRhcHRlciBhc3N1bWVzIHRoZSBQcm9kdWNlckluZGV4IGFuZCBDb25z
dW1lckluZGV4IGFyZSBncm91cGVkCiAgKglhZGphY2VudGx5IGFuZCBpbiB0aGF0IG9yZGVyLgog
ICovCi0gCisKIHN0cnVjdCBhYWNfcWhkciB7Ci0JX19sZTY0IGhlYWRlcl9hZGRyOy8qIEFkZHJl
c3MgdG8gaGFuZCB0aGUgYWRhcHRlciB0byBhY2Nlc3MgCisJX19sZTY0IGhlYWRlcl9hZGRyOy8q
IEFkZHJlc3MgdG8gaGFuZCB0aGUgYWRhcHRlciB0byBhY2Nlc3MKIAkJCSAgICAgIHRvIHRoaXMg
cXVldWUgaGVhZCAqLwogCV9fbGUzMiAqcHJvZHVjZXI7IC8qIFRoZSBwcm9kdWNlciBpbmRleCBm
b3IgdGhpcyBxdWV1ZSAoaG9zdCBhZGRyZXNzKSAqLwogCV9fbGUzMiAqY29uc3VtZXI7IC8qIFRo
ZSBjb25zdW1lciBpbmRleCBmb3IgdGhpcyBxdWV1ZSAoaG9zdCBhZGRyZXNzKSAqLwpAQCAtMjE1
LDcgKzIxNSw3IEBACiAgKglEZWZpbmUgYWxsIHRoZSBldmVudHMgd2hpY2ggdGhlIGFkYXB0ZXIg
d291bGQgbGlrZSB0byBub3RpZnkKICAqCXRoZSBob3N0IG9mLgogICovCi0gCisKICNkZWZpbmUJ
CUhvc3ROb3JtQ21kUXVlCQkxCS8qIENoYW5nZSBpbiBob3N0IG5vcm1hbCBwcmlvcml0eSBjb21t
YW5kIHF1ZXVlICovCiAjZGVmaW5lCQlIb3N0SGlnaENtZFF1ZQkJMgkvKiBDaGFuZ2UgaW4gaG9z
dCBoaWdoIHByaW9yaXR5IGNvbW1hbmQgcXVldWUgKi8KICNkZWZpbmUJCUhvc3ROb3JtUmVzcFF1
ZQkJMwkvKiBDaGFuZ2UgaW4gaG9zdCBub3JtYWwgcHJpb3JpdHkgcmVzcG9uc2UgcXVldWUgKi8K
QEAgLTI4NiwxNyArMjg2LDE3IEBACiAJdTggU3RydWN0VHlwZTsJCS8qIFR5cGUgRklCICovCiAJ
dTggRmxhZ3M7CQkvKiBGbGFncyBmb3IgRklCICovCiAJX19sZTE2IFNpemU7CQkvKiBTaXplIG9m
IHRoaXMgRklCIGluIGJ5dGVzICovCi0JX19sZTE2IFNlbmRlclNpemU7CS8qIFNpemUgb2YgdGhl
IEZJQiBpbiB0aGUgc2VuZGVyIAorCV9fbGUxNiBTZW5kZXJTaXplOwkvKiBTaXplIG9mIHRoZSBG
SUIgaW4gdGhlIHNlbmRlcgogCQkJCSAgIChmb3IgcmVzcG9uc2Ugc2l6aW5nKSAqLwogCV9fbGUz
MiBTZW5kZXJGaWJBZGRyZXNzOyAgLyogSG9zdCBkZWZpbmVkIGRhdGEgaW4gdGhlIEZJQiAqLwot
CV9fbGUzMiBSZWNlaXZlckZpYkFkZHJlc3M7LyogTG9naWNhbCBhZGRyZXNzIG9mIHRoaXMgRklC
IGZvciAKKwlfX2xlMzIgUmVjZWl2ZXJGaWJBZGRyZXNzOy8qIExvZ2ljYWwgYWRkcmVzcyBvZiB0
aGlzIEZJQiBmb3IKIAkJCQkgICAgIHRoZSBhZGFwdGVyICovCiAJdTMyIFNlbmRlckRhdGE7CQkv
KiBQbGFjZSBob2xkZXIgZm9yIHRoZSBzZW5kZXIgdG8gc3RvcmUgZGF0YSAqLwogCXVuaW9uIHsK
IAkJc3RydWN0IHsKLQkJICAgIF9fbGUzMiBfUmVjZWl2ZXJUaW1lU3RhcnQ7IAkvKiBUaW1lc3Rh
bXAgZm9yIAorCQkgICAgX19sZTMyIF9SZWNlaXZlclRpbWVTdGFydDsJLyogVGltZXN0YW1wIGZv
cgogCQkJCQkJICAgcmVjZWlwdCBvZiBmaWIgKi8KLQkJICAgIF9fbGUzMiBfUmVjZWl2ZXJUaW1l
RG9uZTsJLyogVGltZXN0YW1wIGZvciAKKwkJICAgIF9fbGUzMiBfUmVjZWl2ZXJUaW1lRG9uZTsJ
LyogVGltZXN0YW1wIGZvcgogCQkJCQkJICAgY29tcGxldGlvbiBvZiBmaWIgKi8KIAkJfSBfczsK
IAl9IF91OwpAQCAtMzExLDcgKzMxMSw3IEBACiAgKglGSUIgY29tbWFuZHMKICAqLwogCi0jZGVm
aW5lIAlUZXN0Q29tbWFuZFJlc3BvbnNlCQkxCisjZGVmaW5lCQlUZXN0Q29tbWFuZFJlc3BvbnNl
CQkxCiAjZGVmaW5lCQlUZXN0QWRhcHRlckNvbW1hbmQJCTIKIC8qCiAgKglMb3dsZXZlbCBhbmQg
Y29tbSBjb21tYW5kcwpAQCAtMzUwLDEwICszNTAsNiBAQAogI2RlZmluZQkJQ29udGFpbmVyQ29t
bWFuZDY0CQk1MDEKICNkZWZpbmUJCUNvbnRhaW5lclJhd0lvCQkJNTAyCiAvKgotICoJQ2x1c3Rl
ciBDb21tYW5kcwotICovCi0jZGVmaW5lCQlDbHVzdGVyQ29tbWFuZAkgCQk1NTAKLS8qCiAgKglT
Y3NpIFBvcnQgY29tbWFuZHMgKHNjc2kgcGFzc3Rocm91Z2gpCiAgKi8KICNkZWZpbmUJCVNjc2lQ
b3J0Q29tbWFuZAkJCTYwMApAQCAtMzc1LDE5ICszNzEsMTkgQEAKICAqLwogCiBlbnVtIGZpYl94
ZmVyX3N0YXRlIHsKLQlIb3N0T3duZWQgCQkJPSAoMTw8MCksCi0JQWRhcHRlck93bmVkIAkJCT0g
KDE8PDEpLAotCUZpYkluaXRpYWxpemVkIAkJCT0gKDE8PDIpLAotCUZpYkVtcHR5IAkJCT0gKDE8
PDMpLAotCUFsbG9jYXRlZEZyb21Qb29sIAkJPSAoMTw8NCksCi0JU2VudEZyb21Ib3N0IAkJCT0g
KDE8PDUpLAotCVNlbnRGcm9tQWRhcHRlciAJCT0gKDE8PDYpLAotCVJlc3BvbnNlRXhwZWN0ZWQg
CQk9ICgxPDw3KSwKLQlOb1Jlc3BvbnNlRXhwZWN0ZWQgCQk9ICgxPDw4KSwKLQlBZGFwdGVyUHJv
Y2Vzc2VkIAkJPSAoMTw8OSksCi0JSG9zdFByb2Nlc3NlZCAJCQk9ICgxPDwxMCksCi0JSGlnaFBy
aW9yaXR5IAkJCT0gKDE8PDExKSwKLQlOb3JtYWxQcmlvcml0eSAJCQk9ICgxPDwxMiksCisJSG9z
dE93bmVkCQkJPSAoMTw8MCksCisJQWRhcHRlck93bmVkCQkJPSAoMTw8MSksCisJRmliSW5pdGlh
bGl6ZWQJCQk9ICgxPDwyKSwKKwlGaWJFbXB0eQkJCT0gKDE8PDMpLAorCUFsbG9jYXRlZEZyb21Q
b29sCQk9ICgxPDw0KSwKKwlTZW50RnJvbUhvc3QJCQk9ICgxPDw1KSwKKwlTZW50RnJvbUFkYXB0
ZXIJCQk9ICgxPDw2KSwKKwlSZXNwb25zZUV4cGVjdGVkCQk9ICgxPDw3KSwKKwlOb1Jlc3BvbnNl
RXhwZWN0ZWQJCT0gKDE8PDgpLAorCUFkYXB0ZXJQcm9jZXNzZWQJCT0gKDE8PDkpLAorCUhvc3RQ
cm9jZXNzZWQJCQk9ICgxPDwxMCksCisJSGlnaFByaW9yaXR5CQkJPSAoMTw8MTEpLAorCU5vcm1h
bFByaW9yaXR5CQkJPSAoMTw8MTIpLAogCUFzeW5jCQkJCT0gKDE8PDEzKSwKIAlBc3luY0lvCQkJ
CT0gKDE8PDEzKSwJLy8gcnBiZml4OiByZW1vdmUgd2l0aCBuZXcgcmVnaW1lCiAJUGFnZUZpbGVJ
bwkJCT0gKDE8PDE0KSwJLy8gcnBiZml4OiByZW1vdmUgd2l0aCBuZXcgcmVnaW1lCkBAIC00MjAs
NyArNDE2LDcgQEAKIAlfX2xlMzIJQWRhcHRlckZpYkFsaWduOwogCV9fbGUzMglwcmludGZidWY7
CiAJX19sZTMyCXByaW50ZmJ1ZnNpejsKLQlfX2xlMzIJSG9zdFBoeXNNZW1QYWdlczsgICAvKiBu
dW1iZXIgb2YgNGsgcGFnZXMgb2YgaG9zdCAKKwlfX2xlMzIJSG9zdFBoeXNNZW1QYWdlczsgICAv
KiBudW1iZXIgb2YgNGsgcGFnZXMgb2YgaG9zdAogCQkJCSAgICAgICBwaHlzaWNhbCBtZW1vcnkg
Ki8KIAlfX2xlMzIJSG9zdEVsYXBzZWRTZWNvbmRzOyAvKiBudW1iZXIgb2Ygc2Vjb25kcyBzaW5j
ZSAxOTcwLiAqLwogCS8qCkBAIC00ODEsNyArNDc3LDcgQEAKIAogc3RydWN0IGFhY19kcml2ZXJf
aWRlbnQKIHsKLQlpbnQgCSgqaW5pdCkoc3RydWN0IGFhY19kZXYgKmRldik7CisJaW50CSgqaW5p
dCkoc3RydWN0IGFhY19kZXYgKmRldik7CiAJY2hhciAqCW5hbWU7CiAJY2hhciAqCXZuYW1lOwog
CWNoYXIgKgltb2RlbDsKQEAgLTQ4OSw3ICs0ODUsNyBAQAogCWludAlxdWlya3M7CiB9OwogLyoK
LSAqIFNvbWUgYWRhcHRlciBmaXJtd2FyZSBuZWVkcyBjb21tdW5pY2F0aW9uIG1lbW9yeSAKKyAq
IFNvbWUgYWRhcHRlciBmaXJtd2FyZSBuZWVkcyBjb21tdW5pY2F0aW9uIG1lbW9yeQogICogYmVs
b3cgMmdpZy4gVGhpcyB0ZWxscyB0aGUgaW5pdCBmdW5jdGlvbiB0byBzZXQgdGhlCiAgKiBkbWEg
bWFzayBzdWNoIHRoYXQgZmliIG1lbW9yeSB3aWxsIGJlIGFsbG9jYXRlZCB3aGVyZSB0aGUKICAq
IGFkYXB0ZXIgZmlybXdhcmUgY2FuIGdldCB0byBpdC4KQEAgLTUzMSwyOSArNTI3LDI5IEBACiAg
KglwaHlzaWNhbGx5IGNvbnRpZ291cyBibG9jay4gVGhlIGhvc3Qgc3RydWN0dXJlIHRoYXQgZGVm
aW5lcyB0aGUKICAqCWNvbW11aWNhdGlvbiBxdWV1ZXMgd2lsbCBhc3N1bWUgdGhleSBhcmUgZWFj
aCBhIHNlcGFyYXRlIHBoeXNpY2FsbHkKICAqCWNvbnRpZ291cyBtZW1vcnkgcmVnaW9uIHRoYXQg
d2lsbCBzdXBwb3J0IHRoZW0gYWxsIGJlaW5nIG9uZSBiaWcKLSAqCWNvbnRpZ291cyBibG9jay4g
CisgKgljb250aWdvdXMgYmxvY2suCiAgKglUaGVyZSBpcyBhIGNvbW1hbmQgYW5kIHJlc3BvbnNl
IHF1ZXVlIGZvciBlYWNoIGxldmVsIGFuZCBkaXJlY3Rpb24gb2YKICAqCWNvbW11aWNhdGlvbi4g
VGhlc2UgcmVnaW9ucyBhcmUgYWNjZXNzZWQgYnkgYm90aCB0aGUgaG9zdCBhbmQgYWRhcHRlci4K
ICAqLwotIAorCiBzdHJ1Y3QgYWFjX3F1ZXVlIHsKLQl1NjQJCSAJbG9naWNhbDsJLyphZGRyZXNz
IHdlIGdpdmUgdGhlIGFkYXB0ZXIgKi8KKwl1NjQJCQlsb2dpY2FsOwkvKmFkZHJlc3Mgd2UgZ2l2
ZSB0aGUgYWRhcHRlciAqLwogCXN0cnVjdCBhYWNfZW50cnkJKmJhc2U7CQkvKnN5c3RlbSB2aXJ0
dWFsIGFkZHJlc3MgKi8KLQlzdHJ1Y3QgYWFjX3FoZHIgCWhlYWRlcnM7ICAgICAgIAkvKnByb2R1
Y2VyLGNvbnN1bWVyIHEgaGVhZGVycyovCi0JdTMyCSAJCWVudHJpZXM7CS8qTnVtYmVyIG9mIHF1
ZXVlIGVudHJpZXMgKi8KKwlzdHJ1Y3QgYWFjX3FoZHIJCWhlYWRlcnM7CS8qcHJvZHVjZXIsY29u
c3VtZXIgcSBoZWFkZXJzKi8KKwl1MzIJCQllbnRyaWVzOwkvKk51bWJlciBvZiBxdWV1ZSBlbnRy
aWVzICovCiAJd2FpdF9xdWV1ZV9oZWFkX3QJcWZ1bGw7CQkvKkV2ZW50IHRvIHdhaXQgb24gaWYg
cSBmdWxsICovCiAJd2FpdF9xdWV1ZV9oZWFkX3QJY21kcmVhZHk7CS8qQ21kIHJlYWR5IGZyb20g
dGhlIGFkYXB0ZXIgKi8KLSAgICAgICAgICAgICAgICAgIC8qIFRoaXMgaXMgb25seSB2YWxpZCBm
b3IgYWRhcHRlciB0byBob3N0IGNvbW1hbmQgcXVldWVzLiAqLyAKLQlzcGlubG9ja190CSAJKmxv
Y2s7CQkvKiBTcGlubG9jayBmb3IgdGhpcyBxdWV1ZSBtdXN0IHRha2UgdGhpcyBsb2NrIGJlZm9y
ZSBhY2Nlc3NpbmcgdGhlIGxvY2sgKi8KKyAgICAgICAgICAgICAgICAgIC8qIFRoaXMgaXMgb25s
eSB2YWxpZCBmb3IgYWRhcHRlciB0byBob3N0IGNvbW1hbmQgcXVldWVzLiAqLworCXNwaW5sb2Nr
X3QJCSpsb2NrOwkJLyogU3BpbmxvY2sgZm9yIHRoaXMgcXVldWUgbXVzdCB0YWtlIHRoaXMgbG9j
ayBiZWZvcmUgYWNjZXNzaW5nIHRoZSBsb2NrICovCiAJc3BpbmxvY2tfdAkJbG9ja2RhdGE7CS8q
IEFjdHVhbCBsb2NrICh1c2VkIG9ubHkgb24gb25lIHNpZGUgb2YgdGhlIGxvY2spICovCi0Jc3Ry
dWN0IGxpc3RfaGVhZCAJY21kcTsJICAgCS8qIEEgcXVldWUgb2YgRklCcyB3aGljaCBuZWVkIHRv
IGJlIHByY2Vzc2VkIGJ5IHRoZSBGUyB0aHJlYWQuIFRoaXMgaXMgKi8KLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgCQkvKiBvbmx5IHZhbGlkIGZvciBjb21tYW5kIHF1ZXVlcyB3aGlj
aCByZWNlaXZlIGVudHJpZXMgZnJvbSB0aGUgYWRhcHRlci4gKi8KKwlzdHJ1Y3QgbGlzdF9oZWFk
CWNtZHE7CQkvKiBBIHF1ZXVlIG9mIEZJQnMgd2hpY2ggbmVlZCB0byBiZSBwcmNlc3NlZCBieSB0
aGUgRlMgdGhyZWFkLiBUaGlzIGlzICovCisJCQkJCQkvKiBvbmx5IHZhbGlkIGZvciBjb21tYW5k
IHF1ZXVlcyB3aGljaCByZWNlaXZlIGVudHJpZXMgZnJvbSB0aGUgYWRhcHRlci4gKi8KIAl1MzIJ
CQludW1wZW5kaW5nOwkvKiBOdW1iZXIgb2YgZW50cmllcyBvbiBvdXRzdGFuZGluZyBxdWV1ZS4g
Ki8KIAlzdHJ1Y3QgYWFjX2RldiAqCWRldjsJCS8qIEJhY2sgcG9pbnRlciB0byBhZGFwdGVyIHN0
cnVjdHVyZSAqLwogfTsKIAogLyoKLSAqCU1lc3NhZ2UgcXVldWVzLiBUaGUgb3JkZXIgaGVyZSBp
cyBpbXBvcnRhbnQsIHNlZSBhbHNvIHRoZSAKKyAqCU1lc3NhZ2UgcXVldWVzLiBUaGUgb3JkZXIg
aGVyZSBpcyBpbXBvcnRhbnQsIHNlZSBhbHNvIHRoZQogICoJcXVldWUgdHlwZSBvcmRlcmluZwog
ICovCiAKQEAgLTU2NSwxMiArNTYxLDEyIEBACiAvKgogICoJU2FQMSBNZXNzYWdlIFVuaXQgUmVn
aXN0ZXJzCiAgKi8KLSAKKwogc3RydWN0IHNhX2RyYXdicmlkZ2VfQ1NSIHsKLQkJCQkvKglPZmZz
ZXQgCXwgIE5hbWUgKi8KKwkJCQkvKglPZmZzZXQJfCAgTmFtZSAqLwogCV9fbGUzMglyZXNlcnZl
ZFsxMF07CS8qCTAwaC0yN2ggfCAgUmVzZXJ2ZWQgKi8KIAl1OAlMVVRfT2Zmc2V0OwkvKgkyOGgJ
fCAgTG9va3VwIFRhYmxlIE9mZnNldCAqLwotCXU4CXJlc2VydmVkMVszXTsJLyogCTI5aC0yYmgJ
fCAgUmVzZXJ2ZWQgKi8KKwl1OAlyZXNlcnZlZDFbM107CS8qCTI5aC0yYmgJfCAgUmVzZXJ2ZWQg
Ki8KIAlfX2xlMzIJTFVUX0RhdGE7CS8qCTJjaAl8ICBMb291cCBUYWJsZSBEYXRhICovCiAJX19s
ZTMyCXJlc2VydmVkMlsyNl07CS8qCTMwaC05N2gJfCAgUmVzZXJ2ZWQgKi8KIAlfX2xlMTYJUFJJ
Q0xFQVJJUlE7CS8qCTk4aAl8ICBQcmltYXJ5IENsZWFyIElycSAqLwpAQCAtNTg5LDggKzU4NSw4
IEBACiAJX19sZTMyCU1BSUxCT1g1OwkvKgliY2gJfCAgU2NyYXRjaHBhZCA1ICovCiAJX19sZTMy
CU1BSUxCT1g2OwkvKgljMGgJfCAgU2NyYXRjaHBhZCA2ICovCiAJX19sZTMyCU1BSUxCT1g3Owkv
KgljNGgJfCAgU2NyYXRjaHBhZCA3ICovCi0JX19sZTMyCVJPTV9TZXR1cF9EYXRhOwkvKgljOGgg
CXwgIFJvbSBTZXR1cCBhbmQgRGF0YSAqLwotCV9fbGUzMglST01fQ29udHJvbF9BZGRyOy8qCWNj
aCAJfCAgUm9tIENvbnRyb2wgYW5kIEFkZHJlc3MgKi8KKwlfX2xlMzIJUk9NX1NldHVwX0RhdGE7
CS8qCWM4aAl8ICBSb20gU2V0dXAgYW5kIERhdGEgKi8KKwlfX2xlMzIJUk9NX0NvbnRyb2xfQWRk
cjsvKgljY2gJfCAgUm9tIENvbnRyb2wgYW5kIEFkZHJlc3MgKi8KIAlfX2xlMzIJcmVzZXJ2ZWQz
WzEyXTsJLyoJZDBoLWZmaAl8ICByZXNlcnZlZCAqLwogCV9fbGUzMglMVVRbNjRdOwkvKiAgICAx
MDBoLTFmZmgJfCAgTG9va3VwIFRhYmxlIEVudHJpZXMgKi8KIH07CkBAIC02MDMsNyArNTk5LDcg
QEAKICNkZWZpbmUgTWFpbGJveDUJU2FEYkNTUi5NQUlMQk9YNQogI2RlZmluZSBNYWlsYm94NglT
YURiQ1NSLk1BSUxCT1g2CiAjZGVmaW5lIE1haWxib3g3CVNhRGJDU1IuTUFJTEJPWDcKLQkKKwog
I2RlZmluZSBEb29yYmVsbFJlZ19wIFNhRGJDU1IuUFJJU0VUSVJRCiAjZGVmaW5lIERvb3JiZWxs
UmVnX3MgU2FEYkNTUi5TRUNTRVRJUlEKICNkZWZpbmUgRG9vcmJlbGxDbHJSZWdfcCBTYURiQ1NS
LlBSSUNMRUFSSVJRCkBAIC02MTcsMTkgKzYxMywxOSBAQAogI2RlZmluZSBET09SQkVMTF81CTB4
MDAyMAogI2RlZmluZSBET09SQkVMTF82CTB4MDA0MAogCi0JCisKICNkZWZpbmUgUHJpbnRmUmVh
ZHkJRE9PUkJFTExfNQogI2RlZmluZSBQcmludGZEb25lCURPT1JCRUxMXzUKLQkKKwogc3RydWN0
IHNhX3JlZ2lzdGVycyB7CiAJc3RydWN0IHNhX2RyYXdicmlkZ2VfQ1NSCVNhRGJDU1I7CQkJLyog
OThoIC0gYzRoICovCiB9OwotCQorCiAKICNkZWZpbmUgU2FfTUlOSVBPUlRfUkVWSVNJT04JCQkx
CiAKICNkZWZpbmUgc2FfcmVhZHcoQUVQLCBDU1IpCQlyZWFkbCgmKChBRVApLT5yZWdzLnNhLT5D
U1IpKQotI2RlZmluZSBzYV9yZWFkbChBRVAsICBDU1IpCQlyZWFkbCgmKChBRVApLT5yZWdzLnNh
LT5DU1IpKQorI2RlZmluZSBzYV9yZWFkbChBRVAsIENTUikJCXJlYWRsKCYoKEFFUCktPnJlZ3Mu
c2EtPkNTUikpCiAjZGVmaW5lIHNhX3dyaXRldyhBRVAsIENTUiwgdmFsdWUpCXdyaXRldyh2YWx1
ZSwgJigoQUVQKS0+cmVncy5zYS0+Q1NSKSkKICNkZWZpbmUgc2Ffd3JpdGVsKEFFUCwgQ1NSLCB2
YWx1ZSkJd3JpdGVsKHZhbHVlLCAmKChBRVApLT5yZWdzLnNhLT5DU1IpKQogCkBAIC02NDYsMjEg
KzY0MiwyMSBAQAogCV9fbGUzMglJTVJ4WzJdOyAgICAvKgkxMzEwaCAgfCAxMGggfCBJbmJvdW5k
IE1lc3NhZ2UgUmVnaXN0ZXJzICovCiAJX19sZTMyCU9NUnhbMl07ICAgIC8qCTEzMThoICB8IDE4
aCB8IE91dGJvdW5kIE1lc3NhZ2UgUmVnaXN0ZXJzICovCiAJX19sZTMyCUlEUjsJICAgIC8qCTEz
MjBoICB8IDIwaCB8IEluYm91bmQgRG9vcmJlbGwgUmVnaXN0ZXIgKi8KLQlfX2xlMzIJSUlTUjsJ
ICAgIC8qCTEzMjRoICB8IDI0aCB8IEluYm91bmQgSW50ZXJydXB0IAorCV9fbGUzMglJSVNSOwkg
ICAgLyoJMTMyNGggIHwgMjRoIHwgSW5ib3VuZCBJbnRlcnJ1cHQKIAkJCQkJCVN0YXR1cyBSZWdp
c3RlciAqLwotCV9fbGUzMglJSU1SOwkgICAgLyoJMTMyOGggIHwgMjhoIHwgSW5ib3VuZCBJbnRl
cnJ1cHQgCi0JCQkJCSAJTWFzayBSZWdpc3RlciAqLworCV9fbGUzMglJSU1SOwkgICAgLyoJMTMy
OGggIHwgMjhoIHwgSW5ib3VuZCBJbnRlcnJ1cHQKKwkJCQkJCU1hc2sgUmVnaXN0ZXIgKi8KIAlf
X2xlMzIJT0RSOwkgICAgLyoJMTMyQ2ggIHwgMkNoIHwgT3V0Ym91bmQgRG9vcmJlbGwgUmVnaXN0
ZXIgKi8KLQlfX2xlMzIJT0lTUjsJICAgIC8qCTEzMzBoICB8IDMwaCB8IE91dGJvdW5kIEludGVy
cnVwdCAKKwlfX2xlMzIJT0lTUjsJICAgIC8qCTEzMzBoICB8IDMwaCB8IE91dGJvdW5kIEludGVy
cnVwdAogCQkJCQkJU3RhdHVzIFJlZ2lzdGVyICovCi0JX19sZTMyCU9JTVI7CSAgICAvKgkxMzM0
aCAgfCAzNGggfCBPdXRib3VuZCBJbnRlcnJ1cHQgCisJX19sZTMyCU9JTVI7CSAgICAvKgkxMzM0
aCAgfCAzNGggfCBPdXRib3VuZCBJbnRlcnJ1cHQKIAkJCQkJCU1hc2sgUmVnaXN0ZXIgKi8KIAlf
X2xlMzIJcmVzZXJ2ZWQyOyAgLyoJMTMzOGggIHwgMzhoIHwgUmVzZXJ2ZWQgKi8KIAlfX2xlMzIJ
cmVzZXJ2ZWQzOyAgLyoJMTMzQ2ggIHwgM0NoIHwgUmVzZXJ2ZWQgKi8KIAlfX2xlMzIJSW5ib3Vu
ZFF1ZXVlOy8qCTEzNDBoICB8IDQwaCB8IEluYm91bmQgUXVldWUgUG9ydCByZWxhdGl2ZSB0byBm
aXJtd2FyZSAqLwogCV9fbGUzMglPdXRib3VuZFF1ZXVlOy8qMTM0NGggIHwgNDRoIHwgT3V0Ym91
bmQgUXVldWUgUG9ydCByZWxhdGl2ZSB0byBmaXJtd2FyZSAqLwotCQkJICAgIC8qICogTXVzdCBh
Y2Nlc3MgdGhyb3VnaCBBVFUgSW5ib3VuZCAKLQkJCSAgICAgCSBUcmFuc2xhdGlvbiBXaW5kb3cg
Ki8KKwkJCSAgICAvKiAqIE11c3QgYWNjZXNzIHRocm91Z2ggQVRVIEluYm91bmQKKwkJCQkgVHJh
bnNsYXRpb24gV2luZG93ICovCiB9OwogCiBzdHJ1Y3QgcnhfaW5ib3VuZCB7CkBAIC03MTYsMTIg
KzcxMiwxMiBAQAogdHlwZWRlZiB2b2lkICgqZmliX2NhbGxiYWNrKSh2b2lkICpjdHh0LCBzdHJ1
Y3QgZmliICpmaWJjdHgpOwogCiBzdHJ1Y3QgYWFjX2ZpYl9jb250ZXh0IHsKLQlzMTYJIAkJdHlw
ZTsJCS8vIHVzZWQgZm9yIHZlcmlmaWNhdGlvbiBvZiBzdHJ1Y3R1cmUJCi0JczE2CSAJCXNpemU7
CisJczE2CQkJdHlwZTsJCS8vIHVzZWQgZm9yIHZlcmlmaWNhdGlvbiBvZiBzdHJ1Y3R1cmUKKwlz
MTYJCQlzaXplOwogCXUzMgkJCXVuaXF1ZTsJCS8vIHVuaXF1ZSB2YWx1ZSByZXByZXNlbnRpbmcg
dGhpcyBjb250ZXh0CiAJdWxvbmcJCQlqaWZmaWVzOwkvLyB1c2VkIGZvciBjbGVhbnVwIC0gZG1i
IGNoYW5nZWQgdG8gdWxvbmcKIAlzdHJ1Y3QgbGlzdF9oZWFkCW5leHQ7CQkvLyB1c2VkIHRvIGxp
bmsgY29udGV4dCdzIGludG8gYSBsaW5rZWQgbGlzdAotCXN0cnVjdCBzZW1hcGhvcmUgCXdhaXRf
c2VtOwkvLyB0aGlzIGlzIHVzZWQgdG8gd2FpdCBmb3IgdGhlIG5leHQgZmliIHRvIGFycml2ZS4K
KwlzdHJ1Y3Qgc2VtYXBob3JlCXdhaXRfc2VtOwkvLyB0aGlzIGlzIHVzZWQgdG8gd2FpdCBmb3Ig
dGhlIG5leHQgZmliIHRvIGFycml2ZS4KIAlpbnQJCQl3YWl0OwkJLy8gU2V0IHRvIHRydWUgd2hl
biB0aHJlYWQgaXMgaW4gV2FpdEZvclNpbmdsZU9iamVjdAogCXVuc2lnbmVkIGxvbmcJCWNvdW50
OwkJLy8gdG90YWwgbnVtYmVyIG9mIEZJQnMgb24gRmliTGlzdAogCXN0cnVjdCBsaXN0X2hlYWQJ
ZmliX2xpc3Q7CS8vIHRoaXMgaG9sZHMgZmlicyBhbmQgdGhlaXIgYXR0YWNoZCBod19maWJzCkBA
IC03NDAsOSArNzM2LDkgQEAKIAl1OCBFT006MTsJCS8qIEVuZCBPZiBNZWRpdW0gLSByZXNlcnZl
ZCBmb3IgcmFuZG9tIGFjY2VzcyBkZXZpY2VzICovCiAJdTggZmlsZW1hcms6MTsJCS8qIEZpbGVt
YXJrIC0gcmVzZXJ2ZWQgZm9yIHJhbmRvbSBhY2Nlc3MgZGV2aWNlcyAqLwogCi0JdTggaW5mb3Jt
YXRpb25bNF07CS8qIGZvciBkaXJlY3QtYWNjZXNzIGRldmljZXMsIGNvbnRhaW5zIHRoZSB1bnNp
Z25lZCAKLQkJCQkgKiBsb2dpY2FsIGJsb2NrIGFkZHJlc3Mgb3IgcmVzaWR1ZSBhc3NvY2lhdGVk
IHdpdGggCi0JCQkJICogdGhlIHNlbnNlIGtleSAKKwl1OCBpbmZvcm1hdGlvbls0XTsJLyogZm9y
IGRpcmVjdC1hY2Nlc3MgZGV2aWNlcywgY29udGFpbnMgdGhlIHVuc2lnbmVkCisJCQkJICogbG9n
aWNhbCBibG9jayBhZGRyZXNzIG9yIHJlc2lkdWUgYXNzb2NpYXRlZCB3aXRoCisJCQkJICogdGhl
IHNlbnNlIGtleQogCQkJCSAqLwogCXU4IGFkZF9zZW5zZV9sZW47CS8qIG51bWJlciBvZiBhZGRp
dGlvbmFsIHNlbnNlIGJ5dGVzIHRvIGZvbGxvdyB0aGlzIGZpZWxkICovCiAJdTggY21uZF9pbmZv
WzRdOwkvKiBub3QgdXNlZCAqLwpAQCAtNzUyLDcgKzc0OCw3IEBACiAJdTggYml0X3B0cjozOwkJ
LyogaW5kaWNhdGVzIHdoaWNoIGJ5dGUgb2YgdGhlIENEQiBvciBwYXJhbWV0ZXIgZGF0YQogCQkJ
CSAqIHdhcyBpbiBlcnJvcgogCQkJCSAqLwotCXU4IEJQVjoxOwkJLyogYml0IHBvaW50ZXIgdmFs
aWQgKEJQVik6IDEtIGluZGljYXRlcyB0aGF0IAorCXU4IEJQVjoxOwkJLyogYml0IHBvaW50ZXIg
dmFsaWQgKEJQVik6IDEtIGluZGljYXRlcyB0aGF0CiAJCQkJICogdGhlIGJpdF9wdHIgZmllbGQg
aGFzIHZhbGlkIHZhbHVlCiAJCQkJICovCiAJdTggcmVzZXJ2ZWQyOjI7CkBAIC03ODYsMjQgKzc4
MiwyNCBAQAogCS8qCiAJICoJVGhlIEFkYXB0ZXIgdGhhdCB0aGlzIEkvTyBpcyBkZXN0aW5lZCBm
b3IuCiAJICovCi0Jc3RydWN0IGFhY19kZXYgCQkqZGV2OworCXN0cnVjdCBhYWNfZGV2CQkqZGV2
OwogCS8qCiAJICoJVGhpcyBpcyB0aGUgZXZlbnQgdGhlIHNlbmRmaWIgcm91dGluZSB3aWxsIHdh
aXQgb24gaWYgdGhlCiAJICoJY2FsbGVyIGRpZCBub3QgcGFzcyBvbmUgYW5kIHRoaXMgaXMgc3lu
Y2ggaW8uCiAJICovCi0Jc3RydWN0IHNlbWFwaG9yZSAJZXZlbnRfd2FpdDsKKwlzdHJ1Y3Qgc2Vt
YXBob3JlCWV2ZW50X3dhaXQ7CiAJc3BpbmxvY2tfdAkJZXZlbnRfbG9jazsKIAogCXUzMgkJCWRv
bmU7CS8qIGdldHMgc2V0IHRvIDEgd2hlbiBmaWIgaXMgY29tcGxldGUgKi8KLQlmaWJfY2FsbGJh
Y2sgCQljYWxsYmFjazsKLQl2b2lkIAkJCSpjYWxsYmFja19kYXRhOworCWZpYl9jYWxsYmFjawkJ
Y2FsbGJhY2s7CisJdm9pZAkJCSpjYWxsYmFja19kYXRhOwogCXUzMgkJCWZsYWdzOyAvLyB1MzIg
ZG1iIHdhcyB1bG9uZwogCS8qCiAJICoJQW5kIGZvciB0aGUgaW50ZXJuYWwgaXNzdWUvcmVwbHkg
cXVldWVzICh3ZSBtYXkgYmUgYWJsZQogCSAqCXRvIG1lcmdlIHRoZXNlIHR3bykKIAkgKi8KIAlz
dHJ1Y3QgbGlzdF9oZWFkCWZpYmxpbms7Ci0Jdm9pZCAJCQkqZGF0YTsKKwl2b2lkCQkJKmRhdGE7
CiAJc3RydWN0IGh3X2ZpYgkJKmh3X2ZpYl92YTsJCS8qIEFjdHVhbCBzaGFyZWQgb2JqZWN0ICov
CiAJZG1hX2FkZHJfdAkJaHdfZmliX3BhOwkJLyogcGh5c2ljYWwgYWRkcmVzcyBvZiBod19maWIq
LwogfTsKQEAgLTgxMyw3ICs4MDksNyBAQAogICoKICAqCVRoaXMgaXMgcmV0dXJuZWQgYnkgdGhl
IFJlcXVlc3RBZGFwdGVySW5mbyBibG9jawogICovCi0gCisKIHN0cnVjdCBhYWNfYWRhcHRlcl9p
bmZvCiB7CiAJX19sZTMyCXBsYXRmb3JtOwpAQCAtODMyLDcgKzgyOCw3IEBACiAJX19sZTMyCWJp
b3NyZXY7CiAJX19sZTMyCWJpb3NidWlsZDsKIAlfX2xlMzIJY2x1c3RlcjsKLQlfX2xlMzIJY2x1
c3RlcmNoYW5uZWxtYXNrOyAKKwlfX2xlMzIJY2x1c3RlcmNoYW5uZWxtYXNrOwogCV9fbGUzMglz
ZXJpYWxbMl07CiAJX19sZTMyCWJhdHRlcnk7CiAJX19sZTMyCW9wdGlvbnM7CkBAIC05MjIsMTMg
KzkxOCwxMyBAQAogI2RlZmluZSBBQUNfT1BUX0hPU1RfVElNRV9GSUIJCWNwdV90b19sZTMyKDE8
PDQpCiAjZGVmaW5lIEFBQ19PUFRfUkFJRDUwCQkJY3B1X3RvX2xlMzIoMTw8NSkKICNkZWZpbmUg
QUFDX09QVF80R0JfV0lORE9XCQljcHVfdG9fbGUzMigxPDw2KQotI2RlZmluZSBBQUNfT1BUX1ND
U0lfVVBHUkFERUFCTEUgCWNwdV90b19sZTMyKDE8PDcpCisjZGVmaW5lIEFBQ19PUFRfU0NTSV9V
UEdSQURFQUJMRQljcHVfdG9fbGUzMigxPDw3KQogI2RlZmluZSBBQUNfT1BUX1NPRlRfRVJSX1JF
UE9SVAkJY3B1X3RvX2xlMzIoMTw8OCkKLSNkZWZpbmUgQUFDX09QVF9TVVBQT1JURURfUkVDT05E
SVRJT04gCWNwdV90b19sZTMyKDE8PDkpCisjZGVmaW5lIEFBQ19PUFRfU1VQUE9SVEVEX1JFQ09O
RElUSU9OCWNwdV90b19sZTMyKDE8PDkpCiAjZGVmaW5lIEFBQ19PUFRfU0dNQVBfSE9TVDY0CQlj
cHVfdG9fbGUzMigxPDwxMCkKICNkZWZpbmUgQUFDX09QVF9BTEFSTQkJCWNwdV90b19sZTMyKDE8
PDExKQogI2RlZmluZSBBQUNfT1BUX05PTkRBU0QJCQljcHVfdG9fbGUzMigxPDwxMikKLSNkZWZp
bmUgQUFDX09QVF9TQ1NJX01BTkFHRUQgICAgCWNwdV90b19sZTMyKDE8PDEzKQorI2RlZmluZSBB
QUNfT1BUX1NDU0lfTUFOQUdFRAkJY3B1X3RvX2xlMzIoMTw8MTMpCiAjZGVmaW5lIEFBQ19PUFRf
UkFJRF9TQ1NJX01PREUJCWNwdV90b19sZTMyKDE8PDE0KQogI2RlZmluZSBBQUNfT1BUX1NVUFBM
RU1FTlRfQURBUFRFUl9JTkZPCWNwdV90b19sZTMyKDE8PDE2KQogI2RlZmluZSBBQUNfT1BUX05F
V19DT01NCQljcHVfdG9fbGUzMigxPDwxNykKQEAgLTk0OCw3ICs5NDQsNyBAQAogCiAJLyoKIAkg
KglNYXAgZm9yIDEyOCBmaWIgb2JqZWN0cyAoNjRrKQotCSAqLwkKKwkgKi8KIAlkbWFfYWRkcl90
CQlod19maWJfcGE7CiAJc3RydWN0IGh3X2ZpYgkJKmh3X2ZpYl92YTsKIAlzdHJ1Y3QgaHdfZmli
CQkqYWlmX2Jhc2VfdmE7CkBAIC05NTksMjQgKzk1NSwyNCBAQAogCiAJc3RydWN0IGZpYgkJKmZy
ZWVfZmliOwogCXNwaW5sb2NrX3QJCWZpYl9sb2NrOwotCQorCiAJc3RydWN0IGFhY19xdWV1ZV9i
bG9jayAqcXVldWVzOwogCS8qCiAJICoJVGhlIHVzZXIgQVBJIHdpbGwgdXNlIGFuIElPQ1RMIHRv
IHJlZ2lzdGVyIGl0c2VsZiB0byByZWNlaXZlCiAJICoJRklCcyBmcm9tIHRoZSBhZGFwdGVyLiAg
VGhlIGZvbGxvd2luZyBsaXN0IGlzIHVzZWQgdG8ga2VlcAogCSAqCXRyYWNrIG9mIGFsbCB0aGUg
dGhyZWFkcyB0aGF0IGhhdmUgcmVxdWVzdGVkIHRoZXNlIEZJQnMuICBUaGUKLQkgKgltdXRleCBp
cyB1c2VkIHRvIHN5bmNocm9uaXplIGFjY2VzcyB0byBhbGwgZGF0YSBhc3NvY2lhdGVkIAorCSAq
CW11dGV4IGlzIHVzZWQgdG8gc3luY2hyb25pemUgYWNjZXNzIHRvIGFsbCBkYXRhIGFzc29jaWF0
ZWQKIAkgKgl3aXRoIHRoZSBhZGFwdGVyIGZpYnMuCiAJICovCiAJc3RydWN0IGxpc3RfaGVhZAlm
aWJfbGlzdDsKIAogCXN0cnVjdCBhZGFwdGVyX29wcwlhX29wczsKIAl1bnNpZ25lZCBsb25nCQlm
c3JldjsJCS8qIE1haW4gZHJpdmVyJ3MgcmV2aXNpb24gbnVtYmVyICovCi0JCisKIAl1bnNpZ25l
ZAkJYmFzZV9zaXplOwkvKiBTaXplIG9mIG1hcHBlZCBpbiByZWdpb24gKi8KIAlzdHJ1Y3QgYWFj
X2luaXQJCSppbml0OwkJLyogSG9sZHMgaW5pdGlhbGl6YXRpb24gaW5mbyB0byBjb21tdW5pY2F0
ZSB3aXRoIGFkYXB0ZXIgKi8KLQlkbWFfYWRkcl90CQlpbml0X3BhOyAJLyogSG9sZHMgcGh5c2lj
YWwgYWRkcmVzcyBvZiB0aGUgaW5pdCBzdHJ1Y3QgKi8KLQkKKwlkbWFfYWRkcl90CQlpbml0X3Bh
OwkvKiBIb2xkcyBwaHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBpbml0IHN0cnVjdCAqLworCiAJc3Ry
dWN0IHBjaV9kZXYJCSpwZGV2OwkJLyogT3VyIFBDSSBpbnRlcmZhY2UgKi8KIAl2b2lkICoJCQlw
cmludGZidWY7CS8qIHBvaW50ZXIgdG8gYnVmZmVyIHVzZWQgZm9yIHByaW50ZidzIGZyb20gdGhl
IGFkYXB0ZXIgKi8KIAl2b2lkICoJCQljb21tX2FkZHI7CS8qIEJhc2UgYWRkcmVzcyBvZiBDb21t
IGFyZWEgKi8KQEAgLTk5MCwxMSArOTg2LDExIEBACiAJc3RydWN0IGZzYV9kZXZfaW5mbwkqZnNh
X2RldjsKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QJKnRocmVhZDsKIAlpbnQJCQljYXJkdHlwZTsKLQkK
KwogCS8qCiAJICoJVGhlIGZvbGxvd2luZyBpcyB0aGUgZGV2aWNlIHNwZWNpZmljIGV4dGVuc2lv
bi4KIAkgKi8KLSNpZiAoIWRlZmluZWQoQUFDX01JTl9GT09UUFJJTlRfU0laRSkpCisjaWZuZGVm
IEFBQ19NSU5fRk9PVFBSSU5UX1NJWkUKICMJZGVmaW5lIEFBQ19NSU5fRk9PVFBSSU5UX1NJWkUg
ODE5MgogI2VuZGlmCiAJdW5pb24KQEAgLTEwMTUsNyArMTAxMSw3IEBACiAJLyogVGhlc2UgYXJl
IGluIGFkYXB0ZXIgaW5mbyBidXQgdGhleSBhcmUgaW4gdGhlIGlvIGZsb3cgc28KIAkgKiBsZXRz
IGJyZWFrIHRoZW0gb3V0IHNvIHdlIGRvbid0IGhhdmUgdG8gZG8gYW4gQU5EIHRvIGNoZWNrIHRo
ZW0KIAkgKi8KLQl1OAkJCW5vbmRhc2Rfc3VwcG9ydDsgCisJdTgJCQlub25kYXNkX3N1cHBvcnQ7
CiAJdTgJCQljYWNoZV9wcm90ZWN0ZWQ7CiAJdTgJCQlkYWNfc3VwcG9ydDsKIAl1OAkJCXJhaWRf
c2NzaV9tb2RlOwpAQCAtMTA3OCwxNCArMTA3NCwxNCBAQAogLyoKICAqCURlZmluZSB0aGUgY29t
bWFuZCB2YWx1ZXMKICAqLwotIAorCiAjZGVmaW5lCQlOdWxsCQkJMAotI2RlZmluZSAJR2V0QXR0
cmlidXRlcwkJMQotI2RlZmluZSAJU2V0QXR0cmlidXRlcwkJMgotI2RlZmluZSAJTG9va3VwCQkJ
MwotI2RlZmluZSAJUmVhZExpbmsJCTQKLSNkZWZpbmUgCVJlYWQJCQk1Ci0jZGVmaW5lIAlXcml0
ZQkJCTYKKyNkZWZpbmUJCUdldEF0dHJpYnV0ZXMJCTEKKyNkZWZpbmUJCVNldEF0dHJpYnV0ZXMJ
CTIKKyNkZWZpbmUJCUxvb2t1cAkJCTMKKyNkZWZpbmUJCVJlYWRMaW5rCQk0CisjZGVmaW5lCQlS
ZWFkCQkJNQorI2RlZmluZQkJV3JpdGUJCQk2CiAjZGVmaW5lCQlDcmVhdGUJCQk3CiAjZGVmaW5l
CQlNYWtlRGlyZWN0b3J5CQk4CiAjZGVmaW5lCQlTeW1ib2xpY0xpbmsJCTkKQEAgLTExODEsMTkg
KzExNzcsMTkgQEAKIAogc3RydWN0IGFhY19yZWFkCiB7Ci0JX19sZTMyCSAJY29tbWFuZDsKLQlf
X2xlMzIgCQljaWQ7Ci0JX19sZTMyIAkJYmxvY2s7Ci0JX19sZTMyIAkJY291bnQ7CisJX19sZTMy
CQljb21tYW5kOworCV9fbGUzMgkJY2lkOworCV9fbGUzMgkJYmxvY2s7CisJX19sZTMyCQljb3Vu
dDsKIAlzdHJ1Y3Qgc2dtYXAJc2c7CS8vIE11c3QgYmUgbGFzdCBpbiBzdHJ1Y3QgYmVjYXVzZSBp
dCBpcyB2YXJpYWJsZQogfTsKIAogc3RydWN0IGFhY19yZWFkNjQKIHsKLQlfX2xlMzIJIAljb21t
YW5kOwotCV9fbGUxNiAJCWNpZDsKLQlfX2xlMTYgCQlzZWN0b3JfY291bnQ7Ci0JX19sZTMyIAkJ
YmxvY2s7CisJX19sZTMyCQljb21tYW5kOworCV9fbGUxNgkJY2lkOworCV9fbGUxNgkJc2VjdG9y
X2NvdW50OworCV9fbGUzMgkJYmxvY2s7CiAJX19sZTE2CQlwYWQ7CiAJX19sZTE2CQlmbGFnczsK
IAlzdHJ1Y3Qgc2dtYXA2NAlzZzsJLy8gTXVzdCBiZSBsYXN0IGluIHN0cnVjdCBiZWNhdXNlIGl0
IGlzIHZhcmlhYmxlCkBAIC0xMjAxLDI2ICsxMTk3LDI2IEBACiAKIHN0cnVjdCBhYWNfcmVhZF9y
ZXBseQogewotCV9fbGUzMgkgCXN0YXR1czsKLQlfX2xlMzIgCQljb3VudDsKKwlfX2xlMzIJCXN0
YXR1czsKKwlfX2xlMzIJCWNvdW50OwogfTsKIAogc3RydWN0IGFhY193cml0ZQogewogCV9fbGUz
MgkJY29tbWFuZDsKLQlfX2xlMzIgCQljaWQ7Ci0JX19sZTMyIAkJYmxvY2s7Ci0JX19sZTMyIAkJ
Y291bnQ7Ci0JX19sZTMyCSAJc3RhYmxlOwkvLyBOb3QgdXNlZAorCV9fbGUzMgkJY2lkOworCV9f
bGUzMgkJYmxvY2s7CisJX19sZTMyCQljb3VudDsKKwlfX2xlMzIJCXN0YWJsZTsJLy8gTm90IHVz
ZWQKIAlzdHJ1Y3Qgc2dtYXAJc2c7CS8vIE11c3QgYmUgbGFzdCBpbiBzdHJ1Y3QgYmVjYXVzZSBp
dCBpcyB2YXJpYWJsZQogfTsKIAogc3RydWN0IGFhY193cml0ZTY0CiB7Ci0JX19sZTMyCSAJY29t
bWFuZDsKLQlfX2xlMTYgCQljaWQ7Ci0JX19sZTE2IAkJc2VjdG9yX2NvdW50OwotCV9fbGUzMiAJ
CWJsb2NrOworCV9fbGUzMgkJY29tbWFuZDsKKwlfX2xlMTYJCWNpZDsKKwlfX2xlMTYJCXNlY3Rv
cl9jb3VudDsKKwlfX2xlMzIJCWJsb2NrOwogCV9fbGUxNgkJcGFkOwogCV9fbGUxNgkJZmxhZ3M7
CiAjZGVmaW5lCUlPX1RZUEVfV1JJVEUgMHgwMDAwMDAwMApAQCAtMTIzMSw3ICsxMjI3LDcgQEAK
IHN0cnVjdCBhYWNfd3JpdGVfcmVwbHkKIHsKIAlfX2xlMzIJCXN0YXR1czsKLQlfX2xlMzIgCQlj
b3VudDsKKwlfX2xlMzIJCWNvdW50OwogCV9fbGUzMgkJY29tbWl0dGVkOwogfTsKIApAQCAtMTMz
NCwxMCArMTMzMCwxMCBAQAogI2RlZmluZQkJU1JCX05vRGF0YVhmZXIJCSAweDAwMDAKICNkZWZp
bmUJCVNSQl9EaXNhYmxlRGlzY29ubmVjdAkgMHgwMDA0CiAjZGVmaW5lCQlTUkJfRGlzYWJsZVN5
bmNoVHJhbnNmZXIgMHgwMDA4Ci0jZGVmaW5lIAlTUkJfQnlwYXNzRnJvemVuUXVldWUJIDB4MDAx
MAorI2RlZmluZQkJU1JCX0J5cGFzc0Zyb3plblF1ZXVlCSAweDAwMTAKICNkZWZpbmUJCVNSQl9E
aXNhYmxlQXV0b3NlbnNlCSAweDAwMjAKICNkZWZpbmUJCVNSQl9EYXRhSW4JCSAweDAwNDAKLSNk
ZWZpbmUgCVNSQl9EYXRhT3V0CQkgMHgwMDgwCisjZGVmaW5lCQlTUkJfRGF0YU91dAkJIDB4MDA4
MAogCiAvKgogICogU1JCIEZ1bmN0aW9ucyAtIHNldCBpbiBhYWNfc3JiLT5mdW5jdGlvbgpAQCAt
MTM2MCw3ICsxMzU2LDcgQEAKICNkZWZpbmUJU1JCRl9SZW1vdmVEZXZpY2UJMHgwMDE2CiAjZGVm
aW5lCVNSQkZfRG9tYWluVmFsaWRhdGlvbgkweDAwMTcKIAotLyogCisvKgogICogU1JCIFNDU0kg
U3RhdHVzIC0gc2V0IGluIGFhY19zcmItPnNjc2lfc3RhdHVzCiAgKi8KICNkZWZpbmUgU1JCX1NU
QVRVU19QRU5ESU5HICAgICAgICAgICAgICAgICAgMHgwMApAQCAtMTUxOSwxNyArMTUxNSwxNyBA
QAogICovCiAKIHN0cnVjdCBhYWNfbW50ZW50IHsKLQlfX2xlMzIgICAgCQlvaWQ7CisJX19sZTMy
CQkJb2lkOwogCXU4CQkJbmFtZVsxNl07CS8qIGlmIGFwcGxpY2FibGUgKi8KIAlzdHJ1Y3QgY3Jl
YXRpb25faW5mbwljcmVhdGVfaW5mbzsJLyogaWYgYXBwbGljYWJsZSAqLwogCV9fbGUzMgkJCWNh
cGFjaXR5OwotCV9fbGUzMgkJCXZvbDsgICAgCS8qIHN1YnN0cmF0ZSBzdHJ1Y3R1cmUgKi8KLQlf
X2xlMzIJCQlvYmo7CSAgICAgICAgLyogRlRfRklMRVNZUywgZXRjLiAqLwotCV9fbGUzMgkJCXN0
YXRlOwkJLyogdW5yZWFkeSBmb3IgbW91bnRpbmcsIAorCV9fbGUzMgkJCXZvbDsJCS8qIHN1YnN0
cmF0ZSBzdHJ1Y3R1cmUgKi8KKwlfX2xlMzIJCQlvYmo7CQkvKiBGVF9GSUxFU1lTLCBldGMuICov
CisJX19sZTMyCQkJc3RhdGU7CQkvKiB1bnJlYWR5IGZvciBtb3VudGluZywKIAkJCQkJCSAgIHJl
YWRvbmx5LCBldGMuICovCi0JdW5pb24gYWFjX2NvbnRlbnRpbmZvCWZpbGVpbmZvOwkvKiBJbmZv
IHNwZWNpZmljIHRvIGNvbnRlbnQgCisJdW5pb24gYWFjX2NvbnRlbnRpbmZvCWZpbGVpbmZvOwkv
KiBJbmZvIHNwZWNpZmljIHRvIGNvbnRlbnQKIAkJCQkJCSAgIG1hbmFnZXIgKGVnLCBmaWxlc3lz
dGVtKSAqLwotCV9fbGUzMgkJCWFsdG9pZDsJCS8qICE9IG9pZCA8PT0+IHNuYXBzaG90IG9yIAor
CV9fbGUzMgkJCWFsdG9pZDsJCS8qICE9IG9pZCA8PT0+IHNuYXBzaG90IG9yCiAJCQkJCQkgICBi
cm9rZW4gbWlycm9yIGV4aXN0cyAqLwogCV9fbGUzMgkJCWNhcGFjaXR5aGlnaDsKIH07CkBAIC0x
NTQ2LDcgKzE1NDIsNyBAQAogCiBzdHJ1Y3QgYWFjX21vdW50IHsKIAlfX2xlMzIJCXN0YXR1czsK
LQlfX2xlMzIJICAgCXR5cGU7ICAgICAgICAgICAvKiBzaG91bGQgYmUgc2FtZSBhcyB0aGF0IHJl
cXVlc3RlZCAqLworCV9fbGUzMgkJdHlwZTsgICAgICAgICAgIC8qIHNob3VsZCBiZSBzYW1lIGFz
IHRoYXQgcmVxdWVzdGVkICovCiAJX19sZTMyCQljb3VudDsKIAlzdHJ1Y3QgYWFjX21udGVudCBt
bnRbMV07CiB9OwpAQCAtMTYxNiw3ICsxNjEyLDcgQEAKIAl1MzIJZGlza251bTsKIAl1MzIJY251
bTsKIH07Ci0gCisKIHN0cnVjdCBmaWJfaW9jdGwKIHsKIAl1MzIJZmliY3R4OwpAQCAtMTYzMCwx
MCArMTYyNiwxMCBAQAogCV9fbGUzMiB2ZXJzaW9uOwogCV9fbGUzMiBidWlsZDsKIH07Ci0JCisK
IAogLyoKLSAqIAlVZ2x5IC0gbm9uIExpbnV4IGxpa2UgaW9jdGwgY29kaW5nIGZvciBiYWNrIGNv
bXBhdC4KKyAqCVVnbHkgLSBub24gTGludXggbGlrZSBpb2N0bCBjb2RpbmcgZm9yIGJhY2sgY29t
cGF0LgogICovCiAKICNkZWZpbmUgQ1RMX0NPREUoZnVuY3Rpb24sIG1ldGhvZCkgKCAgICAgICAg
ICAgICAgICAgXApAQCAtMTY0MSw3ICsxNjM3LDcgQEAKICkKIAogLyoKLSAqCURlZmluZSB0aGUg
bWV0aG9kIGNvZGVzIGZvciBob3cgYnVmZmVycyBhcmUgcGFzc2VkIGZvciBJL08gYW5kIEZTIAor
ICoJRGVmaW5lIHRoZSBtZXRob2QgY29kZXMgZm9yIGhvdyBidWZmZXJzIGFyZSBwYXNzZWQgZm9y
IEkvTyBhbmQgRlMKICAqCWNvbnRyb2xzCiAgKi8KIApAQCAtMTY1MiwxNSArMTY0OCwxNSBAQAog
ICoJRmlsZXN5c3RlbSBpb2N0bHMKICAqLwogCi0jZGVmaW5lIEZTQUNUTF9TRU5ERklCICAgICAg
ICAgICAgICAgICAgCUNUTF9DT0RFKDIwNTAsIE1FVEhPRF9CVUZGRVJFRCkKLSNkZWZpbmUgRlNB
Q1RMX1NFTkRfUkFXX1NSQiAgICAgICAgICAgICAgIAlDVExfQ09ERSgyMDY3LCBNRVRIT0RfQlVG
RkVSRUQpCisjZGVmaW5lIEZTQUNUTF9TRU5ERklCCQkJCUNUTF9DT0RFKDIwNTAsIE1FVEhPRF9C
VUZGRVJFRCkKKyNkZWZpbmUgRlNBQ1RMX1NFTkRfUkFXX1NSQgkJCUNUTF9DT0RFKDIwNjcsIE1F
VEhPRF9CVUZGRVJFRCkKICNkZWZpbmUgRlNBQ1RMX0RFTEVURV9ESVNLCQkJMHgxNjMKICNkZWZp
bmUgRlNBQ1RMX1FVRVJZX0RJU0sJCQkweDE3MwogI2RlZmluZSBGU0FDVExfT1BFTl9HRVRfQURB
UFRFUl9GSUIJCUNUTF9DT0RFKDIxMDAsIE1FVEhPRF9CVUZGRVJFRCkKICNkZWZpbmUgRlNBQ1RM
X0dFVF9ORVhUX0FEQVBURVJfRklCCQlDVExfQ09ERSgyMTAxLCBNRVRIT0RfQlVGRkVSRUQpCiAj
ZGVmaW5lIEZTQUNUTF9DTE9TRV9HRVRfQURBUFRFUl9GSUIJCUNUTF9DT0RFKDIxMDIsIE1FVEhP
RF9CVUZGRVJFRCkKICNkZWZpbmUgRlNBQ1RMX01JTklQT1JUX1JFVl9DSEVDSyAgICAgICAgICAg
ICAgIENUTF9DT0RFKDIxMDcsIE1FVEhPRF9CVUZGRVJFRCkKLSNkZWZpbmUgRlNBQ1RMX0dFVF9Q
Q0lfSU5GTyAgICAgICAgICAgICAgIAlDVExfQ09ERSgyMTE5LCBNRVRIT0RfQlVGRkVSRUQpCisj
ZGVmaW5lIEZTQUNUTF9HRVRfUENJX0lORk8JCQlDVExfQ09ERSgyMTE5LCBNRVRIT0RfQlVGRkVS
RUQpCiAjZGVmaW5lIEZTQUNUTF9GT1JDRV9ERUxFVEVfRElTSwkJQ1RMX0NPREUoMjEyMCwgTUVU
SE9EX05FSVRIRVIpCiAjZGVmaW5lIEZTQUNUTF9HRVRfQ09OVEFJTkVSUwkJCTIxMzEKICNkZWZp
bmUgRlNBQ1RMX1NFTkRfTEFSR0VfRklCCQkJQ1RMX0NPREUoMjEzOCwgTUVUSE9EX0JVRkZFUkVE
KQpAQCAtMTY2OSw3ICsxNjY1LDcgQEAKIHN0cnVjdCBhYWNfY29tbW9uCiB7CiAJLyoKLQkgKglJ
ZiB0aGlzIHZhbHVlIGlzIHNldCB0byAxIHRoZW4gaW50ZXJydXB0IG1vZGVyYXRpb24gd2lsbCBv
Y2N1ciAKKwkgKglJZiB0aGlzIHZhbHVlIGlzIHNldCB0byAxIHRoZW4gaW50ZXJydXB0IG1vZGVy
YXRpb24gd2lsbCBvY2N1cgogCSAqCWluIHRoZSBiYXNlIGNvbW11aWNhdGlvbiBzdXBwb3J0Lgog
CSAqLwogCXUzMiBpcnFfbW9kOwpAQCAtMTY5OCwxMSArMTY5NCwxMSBAQAogICoJVGhlIGZvbGxv
d2luZyBtYWNybyBpcyB1c2VkIHdoZW4gc2VuZGluZyBhbmQgcmVjZWl2aW5nIEZJQnMuIEl0IGlz
CiAgKglvbmx5IHVzZWQgZm9yIGRlYnVnZ2luZy4KICAqLwotIAorCiAjaWZkZWYgREJHCiAjZGVm
aW5lCUZJQl9DT1VOVEVSX0lOQ1JFTUVOVChjb3VudGVyKQkJKGNvdW50ZXIpKysKICNlbHNlCi0j
ZGVmaW5lCUZJQl9DT1VOVEVSX0lOQ1JFTUVOVChjb3VudGVyKQkJCisjZGVmaW5lCUZJQl9DT1VO
VEVSX0lOQ1JFTUVOVChjb3VudGVyKQogI2VuZGlmCiAKIC8qCkBAIC0xNzM0LDE3ICsxNzMwLDE3
IEBACiAgKgogICoJVGhlIGFkYXB0ZXIgcmVwb3J0cyBpcyBwcmVzZW50IHN0YXRlIHRocm91Z2gg
dGhlIHBoYXNlLiAgT25seQogICoJYSBzaW5nbGUgcGhhc2Ugc2hvdWxkIGJlIGV2ZXIgYmUgc2V0
LiAgRWFjaCBwaGFzZSBjYW4gaGF2ZSBtdWx0aXBsZQotICoJcGhhc2Ugc3RhdHVzIGJpdHMgdG8g
cHJvdmlkZSBtb3JlIGRldGFpbGVkIGluZm9ybWF0aW9uIGFib3V0IHRoZSAKLSAqCXN0YXRlIG9m
IHRoZSBib2FyZC4gIENhcmUgc2hvdWxkIGJlIHRha2VuIHRvIGVuc3VyZSB0aGF0IGFueSBwaGFz
ZSAKKyAqCXBoYXNlIHN0YXR1cyBiaXRzIHRvIHByb3ZpZGUgbW9yZSBkZXRhaWxlZCBpbmZvcm1h
dGlvbiBhYm91dCB0aGUKKyAqCXN0YXRlIG9mIHRoZSBib2FyZC4gIENhcmUgc2hvdWxkIGJlIHRh
a2VuIHRvIGVuc3VyZSB0aGF0IGFueSBwaGFzZQogICoJc3RhdHVzIGJpdHMgdGhhdCBhcmUgc2V0
IHdoZW4gY2hhbmdpbmcgdGhlIHBoYXNlIGFyZSBhbHNvIHZhbGlkCiAgKglmb3IgdGhlIG5ldyBw
aGFzZSBvciBiZSBjbGVhcmVkIG91dC4gIEFkYXB0ZXIgc29mdHdhcmUgKG1vbml0b3IsCi0gKglp
Zmxhc2gsIGtlcm5lbCkgaXMgcmVzcG9uc2libGUgZm9yIHByb3Blcmx5IG1haW50aW5pbmcgdGhl
IHBoYXNlIAorICoJaWZsYXNoLCBrZXJuZWwpIGlzIHJlc3BvbnNpYmxlIGZvciBwcm9wZXJseSBt
YWludGluaW5nIHRoZSBwaGFzZQogICoJc3RhdHVzIG1haWxib3ggd2hlbiBpdCBpcyBydW5uaW5n
LgotICoJCQkJCQkJCQkJCQotICoJTU9OS0VSX0FQSSBQaGFzZXMJCQkJCQkJCiAgKgotICoJUGhh
c2VzIGFyZSBiaXQgb3JpZW50ZWQuICBJdCBpcyBOT1QgdmFsaWQgIHRvIGhhdmUgbXVsdGlwbGUg
Yml0cyBzZXQJCQkJCQkKLSAqLwkJCQkJCisgKglNT05LRVJfQVBJIFBoYXNlcworICoKKyAqCVBo
YXNlcyBhcmUgYml0IG9yaWVudGVkLiAgSXQgaXMgTk9UIHZhbGlkICB0byBoYXZlIG11bHRpcGxl
IGJpdHMgc2V0CisgKi8KIAogI2RlZmluZQlTRUxGX1RFU1RfRkFJTEVECQkweDAwMDAwMDA0CiAj
ZGVmaW5lCU1PTklUT1JfUEFOSUMJCQkweDAwMDAwMDIwCkBAIC0xNzY3LDggKzE3NjMsOCBAQAog
ICoJRm9yIEZJQiBjb21tdW5pY2F0aW9uLCB3ZSBuZWVkIGFsbCBvZiB0aGUgZm9sbG93aW5nIHRo
aW5ncwogICoJdG8gc2VuZCBiYWNrIHRvIHRoZSB1c2VyLgogICovCi0gCi0jZGVmaW5lIAlBaWZD
bWRFdmVudE5vdGlmeQkxCS8qIE5vdGlmeSBvZiBldmVudCAqLworCisjZGVmaW5lCQlBaWZDbWRF
dmVudE5vdGlmeQkxCS8qIE5vdGlmeSBvZiBldmVudCAqLwogI2RlZmluZQkJCUFpZkVuQ29uZmln
Q2hhbmdlCTMJLyogQWRhcHRlciBjb25maWd1cmF0aW9uIGNoYW5nZSAqLwogI2RlZmluZQkJCUFp
ZkVuQ29udGFpbmVyQ2hhbmdlCTQJLyogQ29udGFpbmVyIGNvbmZpZ3VyYXRpb24gY2hhbmdlICov
CiAjZGVmaW5lCQkJQWlmRW5EZXZpY2VGYWlsdXJlCTUJLyogU0NTSSBkZXZpY2UgZmFpbGVkICov
CkBAIC0xNzkyLDExICsxNzg4LDExIEBACiAjZGVmaW5lCQkJQWlmRGVuVm9sdW1lRXh0ZW5kQ29t
cGxldGUgMjAxIC8qIEEgdm9sdW1lIGV4dGVuZCBjb21wbGV0ZWQgKi8KICNkZWZpbmUJCUFpZlJl
cUpvYkxpc3QJCTEwMAkvKiBHZXRzIGJhY2sgY29tcGxldGUgam9iIGxpc3QgKi8KICNkZWZpbmUJ
CUFpZlJlcUpvYnNGb3JDdHIJMTAxCS8qIEdldHMgYmFjayBqb2JzIGZvciBzcGVjaWZpYyBjb250
YWluZXIgKi8KLSNkZWZpbmUJCUFpZlJlcUpvYnNGb3JTY3NpCTEwMgkvKiBHZXRzIGJhY2sgam9i
cyBmb3Igc3BlY2lmaWMgU0NTSSBkZXZpY2UgKi8gCi0jZGVmaW5lCQlBaWZSZXFKb2JSZXBvcnQJ
CTEwMwkvKiBHZXRzIGJhY2sgYSBzcGVjaWZpYyBqb2IgcmVwb3J0IG9yIGxpc3Qgb2YgdGhlbSAq
LyAKKyNkZWZpbmUJCUFpZlJlcUpvYnNGb3JTY3NpCTEwMgkvKiBHZXRzIGJhY2sgam9icyBmb3Ig
c3BlY2lmaWMgU0NTSSBkZXZpY2UgKi8KKyNkZWZpbmUJCUFpZlJlcUpvYlJlcG9ydAkJMTAzCS8q
IEdldHMgYmFjayBhIHNwZWNpZmljIGpvYiByZXBvcnQgb3IgbGlzdCBvZiB0aGVtICovCiAjZGVm
aW5lCQlBaWZSZXFUZXJtaW5hdGVKb2IJMTA0CS8qIFRlcm1pbmF0ZXMgam9iICovCiAjZGVmaW5l
CQlBaWZSZXFTdXNwZW5kSm9iCTEwNQkvKiBTdXNwZW5kcyBhIGpvYiAqLwotI2RlZmluZQkJQWlm
UmVxUmVzdW1lSm9iCQkxMDYJLyogUmVzdW1lcyBhIGpvYiAqLyAKKyNkZWZpbmUJCUFpZlJlcVJl
c3VtZUpvYgkJMTA2CS8qIFJlc3VtZXMgYSBqb2IgKi8KICNkZWZpbmUJCUFpZlJlcVNlbmRBUElS
ZXBvcnQJMTA3CS8qIEFQSSBnZW5lcmljIHJlcG9ydCByZXF1ZXN0cyAqLwogI2RlZmluZQkJQWlm
UmVxQVBJSm9iU3RhcnQJMTA4CS8qIFN0YXJ0IGEgam9iIGZyb20gdGhlIEFQSSAqLwogI2RlZmlu
ZQkJQWlmUmVxQVBJSm9iVXBkYXRlCTEwOQkvKiBVcGRhdGUgYSBqb2IgcmVwb3J0IGZyb20gdGhl
IEFQSSAqLwpAQCAtMTgxNSw4ICsxODExLDggQEAKIH07CiAKIC8qKgotICogCUNvbnZlcnQgY2Fw
YWNpdHkgdG8gY3lsaW5kZXJzCi0gKiAgCWFjY291bnRpbmcgZm9yIHRoZSBmYWN0IGNhcGFjaXR5
IGNvdWxkIGJlIGEgNjQgYml0IHZhbHVlCisgKglDb252ZXJ0IGNhcGFjaXR5IHRvIGN5bGluZGVy
cworICoJYWNjb3VudGluZyBmb3IgdGhlIGZhY3QgY2FwYWNpdHkgY291bGQgYmUgYSA2NCBiaXQg
dmFsdWUKICAqCiAgKi8KIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGNhcF90b19jeWxzKHNl
Y3Rvcl90IGNhcGFjaXR5LCB1bnNpZ25lZCBkaXZpc29yKQpkaWZmIC1ydSBhL2RyaXZlcnMvc2Nz
aS9hYWNyYWlkL2NvbW1jdHJsLmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jCi0t
LSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1jdHJsLmMJMjAwOC0wMS0xNiAwOToyODowOC4y
NDU4MzYwNTcgLTA1MDAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbWN0cmwuYwkyMDA4
LTAxLTE2IDEwOjA4OjQxLjQ5ODk1MTExOSAtMDUwMApAQCAtNDgsMTMgKzQ4LDEzIEBACiAgKglp
b2N0bF9zZW5kX2ZpYgktCXNlbmQgYSBGSUIgZnJvbSB1c2Vyc3BhY2UKICAqCUBkZXY6CWFkYXB0
ZXIgaXMgYmVpbmcgcHJvY2Vzc2VkCiAgKglAYXJnOglhcmd1bWVudHMgdG8gdGhlIGlvY3RsIGNh
bGwKLSAqCQorICoKICAqCVRoaXMgcm91dGluZSBzZW5kcyBhIGZpYiB0byB0aGUgYWRhcHRlciBv
biBiZWhhbGYgb2YgYSB1c2VyIGxldmVsCiAgKglwcm9ncmFtLgogICovCiAjIGRlZmluZSBBQUNf
REVCVUdfUFJFQU1CTEUJS0VSTl9JTkZPCiAjIGRlZmluZSBBQUNfREVCVUdfUE9TVEFNQkxFCi0g
CisKIHN0YXRpYyBpbnQgaW9jdGxfc2VuZF9maWIoc3RydWN0IGFhY19kZXYgKiBkZXYsIHZvaWQg
X191c2VyICphcmcpCiB7CiAJc3RydWN0IGh3X2ZpYiAqIGtmaWI7CkBAIC03MSw3ICs3MSw3IEBA
CiAJaWYoZmlicHRyID09IE5VTEwpIHsKIAkJcmV0dXJuIC1FTk9NRU07CiAJfQotCQkKKwogCWtm
aWIgPSBmaWJwdHItPmh3X2ZpYl92YTsKIAkvKgogCSAqCUZpcnN0IGNvcHkgaW4gdGhlIGhlYWRl
ciBzbyB0aGF0IHdlIGNhbiBjaGVjayB0aGUgc2l6ZSBmaWVsZC4KQEAgLTEwOSw3ICsxMDksNyBA
QAogCWlmIChrZmliLT5oZWFkZXIuQ29tbWFuZCA9PSBjcHVfdG9fbGUxNihUYWtlQUJyZWFrUHQp
KSB7CiAJCWFhY19hZGFwdGVyX2ludGVycnVwdChkZXYpOwogCQkvKgotCQkgKiBTaW5jZSB3ZSBk
aWRuJ3QgcmVhbGx5IHNlbmQgYSBmaWIsIHplcm8gb3V0IHRoZSBzdGF0ZSB0byBhbGxvdyAKKwkJ
ICogU2luY2Ugd2UgZGlkbid0IHJlYWxseSBzZW5kIGEgZmliLCB6ZXJvIG91dCB0aGUgc3RhdGUg
dG8gYWxsb3cKIAkJICogY2xlYW51cCBjb2RlIG5vdCB0byBhc3NlcnQuCiAJCSAqLwogCQlrZmli
LT5oZWFkZXIuWGZlclN0YXRlID0gMDsKQEAgLTE2OSw3ICsxNjksNyBAQAogCiAJCWZpYmN0eC0+
dHlwZSA9IEZTQUZTX05UQ19HRVRfQURBUFRFUl9GSUJfQ09OVEVYVDsKIAkJZmliY3R4LT5zaXpl
ID0gc2l6ZW9mKHN0cnVjdCBhYWNfZmliX2NvbnRleHQpOwotIAkJLyoKKwkJLyoKIAkJICoJWWVz
IHllcywgSSBrbm93IHRoaXMgY291bGQgYmUgYW4gaW5kZXgsIGJ1dCB3ZSBoYXZlIGEKIAkJICog
YmV0dGVyIGd1YXJhbnRlZSBvZiB1bmlxdWVuZXNzIGZvciB0aGUgbG9ja2VkIGxvb3AgYmVsb3cu
CiAJCSAqIFdpdGhvdXQgdGhlIGFpZCBvZiBhIHBlcnNpc3RlbnQgaGlzdG9yeSwgdGhpcyBhbHNv
IGhlbHBzCkBAIC0xODksNyArMTg5LDcgQEAKIAkJSU5JVF9MSVNUX0hFQUQoJmZpYmN0eC0+Zmli
X2xpc3QpOwogCQlmaWJjdHgtPmppZmZpZXMgPSBqaWZmaWVzL0haOwogCQkvKgotCQkgKglOb3cg
YWRkIHRoaXMgY29udGV4dCBvbnRvIHRoZSBhZGFwdGVyJ3MgCisJCSAqCU5vdyBhZGQgdGhpcyBj
b250ZXh0IG9udG8gdGhlIGFkYXB0ZXIncwogCQkgKglBZGFwdGVyRmliQ29udGV4dCBsaXN0Lgog
CQkgKi8KIAkJc3Bpbl9sb2NrX2lycXNhdmUoJmRldi0+ZmliX2xvY2ssIGZsYWdzKTsKQEAgLTIw
NywxMiArMjA3LDEyIEBACiAJCX0KIAkJbGlzdF9hZGRfdGFpbCgmZmliY3R4LT5uZXh0LCAmZGV2
LT5maWJfbGlzdCk7CiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldi0+ZmliX2xvY2ssIGZs
YWdzKTsKLQkJaWYgKGNvcHlfdG9fdXNlcihhcmcsICAmZmliY3R4LT51bmlxdWUsIAorCQlpZiAo
Y29weV90b191c2VyKGFyZywgJmZpYmN0eC0+dW5pcXVlLAogCQkJCQkJc2l6ZW9mKGZpYmN0eC0+
dW5pcXVlKSkpIHsKIAkJCXN0YXR1cyA9IC1FRkFVTFQ7CiAJCX0gZWxzZSB7CiAJCQlzdGF0dXMg
PSAwOwotCQl9CQorCQl9CiAJfQogCXJldHVybiBzdGF0dXM7CiB9CkBAIC0yMjEsOCArMjIxLDgg
QEAKICAqCW5leHRfZ2V0YWRhcHRlcl9maWIJLQlnZXQgdGhlIG5leHQgZmliCiAgKglAZGV2OiBh
ZGFwdGVyIHRvIHVzZQogICoJQGFyZzogaW9jdGwgYXJndW1lbnQKLSAqCQotICogCVRoaXMgcm91
dGluZSB3aWxsIGdldCB0aGUgbmV4dCBGaWIsIGlmIGF2YWlsYWJsZSwgZnJvbSB0aGUgQWRhcHRl
ckZpYkNvbnRleHQKKyAqCisgKglUaGlzIHJvdXRpbmUgd2lsbCBnZXQgdGhlIG5leHQgRmliLCBp
ZiBhdmFpbGFibGUsIGZyb20gdGhlIEFkYXB0ZXJGaWJDb250ZXh0CiAgKglwYXNzZWQgaW4gZnJv
bSB0aGUgdXNlci4KICAqLwogCkBAIC0yMzQsNyArMjM0LDcgQEAKIAlpbnQgc3RhdHVzOwogCXN0
cnVjdCBsaXN0X2hlYWQgKiBlbnRyeTsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwotCQorCiAJaWYo
Y29weV9mcm9tX3VzZXIoKHZvaWQgKikmZiwgYXJnLCBzaXplb2Yoc3RydWN0IGZpYl9pb2N0bCkp
KQogCQlyZXR1cm4gLUVGQVVMVDsKIAkvKgpAQCAtMjgwLDcgKzI4MCw3IEBACiAJCSAqLwogCQll
bnRyeSA9IGZpYmN0eC0+ZmliX2xpc3QubmV4dDsKIAkJbGlzdF9kZWwoZW50cnkpOwotCQkKKwog
CQlmaWIgPSBsaXN0X2VudHJ5KGVudHJ5LCBzdHJ1Y3QgZmliLCBmaWJsaW5rKTsKIAkJZmliY3R4
LT5jb3VudC0tOwogCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXYtPmZpYl9sb2NrLCBmbGFn
cyk7CkBAIC0yODgsNyArMjg4LDcgQEAKIAkJCWtmcmVlKGZpYi0+aHdfZmliX3ZhKTsKIAkJCWtm
cmVlKGZpYik7CiAJCQlyZXR1cm4gLUVGQVVMVDsKLQkJfQkKKwkJfQogCQkvKgogCQkgKglGcmVl
IHRoZSBzcGFjZSBvY2N1cGllZCBieSB0aGlzIGNvcHkgb2YgdGhlIGZpYi4KIAkJICovCkBAIC0z
MTcsNyArMzE3LDcgQEAKIAkJCX0KIAkJfSBlbHNlIHsKIAkJCXN0YXR1cyA9IC1FQUdBSU47Ci0J
CX0JCisJCX0KIAl9CiAJZmliY3R4LT5qaWZmaWVzID0gamlmZmllcy9IWjsKIAlyZXR1cm4gc3Rh
dHVzOwpAQCAtMzY3LDcgKzM2Nyw3IEBACiAgKgogICoJVGhpcyByb3V0aW5lIHdpbGwgY2xvc2Ug
ZG93biB0aGUgZmliY3R4IHBhc3NlZCBpbiBmcm9tIHRoZSB1c2VyLgogICovCi0gCisKIHN0YXRp
YyBpbnQgY2xvc2VfZ2V0YWRhcHRlcl9maWIoc3RydWN0IGFhY19kZXYgKiBkZXYsIHZvaWQgX191
c2VyICphcmcpCiB7CiAJc3RydWN0IGFhY19maWJfY29udGV4dCAqZmliY3R4OwpAQCAtNDE0LDcg
KzQxNCw3IEBACiAgKglAYXJnOiBpb2N0bCBhcmd1bWVudHMKICAqCiAgKglUaGlzIHJvdXRpbmUg
cmV0dXJucyB0aGUgZHJpdmVyIHZlcnNpb24uCi0gKiAgICAgIFVuZGVyIExpbnV4LCB0aGVyZSBo
YXZlIGJlZW4gbm8gdmVyc2lvbiBpbmNvbXBhdGliaWxpdGllcywgc28gdGhpcyBpcyAKKyAqICAg
ICAgVW5kZXIgTGludXgsIHRoZXJlIGhhdmUgYmVlbiBubyB2ZXJzaW9uIGluY29tcGF0aWJpbGl0
aWVzLCBzbyB0aGlzIGlzCiAgKiAgICAgIHNpbXBsZSEKICAqLwogCkBAIC00MjUsMTIgKzQyNSwx
MiBAQAogCXUzMiB2ZXJzaW9uOwogCiAJcmVzcG9uc2UuY29tcGF0ID0gMTsKLQl2ZXJzaW9uID0g
KHNpbXBsZV9zdHJ0b2woZHJpdmVyX3ZlcnNpb24sIAorCXZlcnNpb24gPSAoc2ltcGxlX3N0cnRv
bChkcml2ZXJfdmVyc2lvbiwKIAkJCQkmZHJpdmVyX3ZlcnNpb24sIDEwKSA8PCAyNCkgfCAweDAw
MDAwNDAwOwogCXZlcnNpb24gKz0gc2ltcGxlX3N0cnRvbChkcml2ZXJfdmVyc2lvbiArIDEsICZk
cml2ZXJfdmVyc2lvbiwgMTApIDw8IDE2OwogCXZlcnNpb24gKz0gc2ltcGxlX3N0cnRvbChkcml2
ZXJfdmVyc2lvbiArIDEsIE5VTEwsIDEwKTsKIAlyZXNwb25zZS52ZXJzaW9uID0gY3B1X3RvX2xl
MzIodmVyc2lvbik7Ci0jCWlmIChkZWZpbmVkKEFBQ19EUklWRVJfQlVJTEQpKQorIwlpZmRlZiBB
QUNfRFJJVkVSX0JVSUxECiAJCXJlc3BvbnNlLmJ1aWxkID0gY3B1X3RvX2xlMzIoQUFDX0RSSVZF
Ul9CVUlMRCk7CiAjCWVsc2UKIAkJcmVzcG9uc2UuYnVpbGQgPSBjcHVfdG9fbGUzMig5OTk5KTsK
QEAgLTQ3NCw3ICs0NzQsNyBAQAogCQlyZXR1cm4gLUVCVVNZOwogCX0KIAlpZiAoIWNhcGFibGUo
Q0FQX1NZU19BRE1JTikpewotCQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3JhaWQ6IE5vIHBlcm1p
c3Npb24gdG8gc2VuZCByYXcgc3JiXG4iKSk7IAorCQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3Jh
aWQ6IE5vIHBlcm1pc3Npb24gdG8gc2VuZCByYXcgc3JiXG4iKSk7CiAJCXJldHVybiAtRVBFUk07
CiAJfQogCS8qCkBAIC00ODksNyArNDg5LDcgQEAKIAogCW1lbXNldChzZ19saXN0LCAwLCBzaXpl
b2Yoc2dfbGlzdCkpOyAvKiBjbGVhbnVwIG1heSB0YWtlIGlzc3VlICovCiAJaWYoY29weV9mcm9t
X3VzZXIoJmZpYnNpemUsICZ1c2VyX3NyYi0+Y291bnQsc2l6ZW9mKHUzMikpKXsKLQkJZHByaW50
aygoS0VSTl9ERUJVRyJhYWNyYWlkOiBDb3VsZCBub3QgY29weSBkYXRhIHNpemUgZnJvbSB1c2Vy
XG4iKSk7IAorCQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3JhaWQ6IENvdWxkIG5vdCBjb3B5IGRh
dGEgc2l6ZSBmcm9tIHVzZXJcbiIpKTsKIAkJcmNvZGUgPSAtRUZBVUxUOwogCQlnb3RvIGNsZWFu
dXA7CiAJfQpAQCAtNTA2LDcgKzUwNiw3IEBACiAJCWdvdG8gY2xlYW51cDsKIAl9CiAJaWYoY29w
eV9mcm9tX3VzZXIodXNlcl9zcmJjbWQsIHVzZXJfc3JiLGZpYnNpemUpKXsKLQkJZHByaW50aygo
S0VSTl9ERUJVRyJhYWNyYWlkOiBDb3VsZCBub3QgY29weSBzcmIgZnJvbSB1c2VyXG4iKSk7IAor
CQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3JhaWQ6IENvdWxkIG5vdCBjb3B5IHNyYiBmcm9tIHVz
ZXJcbiIpKTsKIAkJcmNvZGUgPSAtRUZBVUxUOwogCQlnb3RvIGNsZWFudXA7CiAJfQpAQCAtNTI1
LDcgKzUyNSw3IEBACiAJc3JiY21kLT5yZXRyeV9saW1pdCA9IDA7IC8vIE9ic29sZXRlIHBhcmFt
ZXRlcgogCXNyYmNtZC0+Y2RiX3NpemUgPSBjcHVfdG9fbGUzMih1c2VyX3NyYmNtZC0+Y2RiX3Np
emUpOwogCW1lbWNweShzcmJjbWQtPmNkYiwgdXNlcl9zcmJjbWQtPmNkYiwgc2l6ZW9mKHNyYmNt
ZC0+Y2RiKSk7Ci0JCisKIAlzd2l0Y2ggKGZsYWdzICYgKFNSQl9EYXRhSW4gfCBTUkJfRGF0YU91
dCkpIHsKIAljYXNlIFNSQl9EYXRhT3V0OgogCQlkYXRhX2RpciA9IERNQV9UT19ERVZJQ0U7CkBA
IC01OTMsNyArNTkzLDcgQEAKIAkJCQlzZ19saXN0W2ldID0gcDsgLy8gc2F2ZSBzbyB3ZSBjYW4g
Y2xlYW4gdXAgbGF0ZXIKIAkJCQlzZ19pbmR4ID0gaTsKIAotCQkJCWlmKCBmbGFncyAmIFNSQl9E
YXRhT3V0ICl7CisJCQkJaWYgKGZsYWdzICYgU1JCX0RhdGFPdXQpIHsKIAkJCQkJaWYoY29weV9m
cm9tX3VzZXIocCxzZ191c2VyW2ldLHVwc2ctPnNnW2ldLmNvdW50KSl7CiAJCQkJCQlkcHJpbnRr
KChLRVJOX0RFQlVHImFhY3JhaWQ6IENvdWxkIG5vdCBjb3B5IHNnIGRhdGEgZnJvbSB1c2VyXG4i
KSk7CiAJCQkJCQlyY29kZSA9IC1FRkFVTFQ7CkBAIC02MzYsNyArNjM2LDcgQEAKIAkJCQlzZ19s
aXN0W2ldID0gcDsgLy8gc2F2ZSBzbyB3ZSBjYW4gY2xlYW4gdXAgbGF0ZXIKIAkJCQlzZ19pbmR4
ID0gaTsKIAotCQkJCWlmKCBmbGFncyAmIFNSQl9EYXRhT3V0ICl7CisJCQkJaWYgKGZsYWdzICYg
U1JCX0RhdGFPdXQpIHsKIAkJCQkJaWYoY29weV9mcm9tX3VzZXIocCxzZ191c2VyW2ldLHVwc2ct
PnNnW2ldLmNvdW50KSl7CiAJCQkJCQlrZnJlZSAodXNnKTsKIAkJCQkJCWRwcmludGsoKEtFUk5f
REVCVUciYWFjcmFpZDogQ291bGQgbm90IGNvcHkgc2cgZGF0YSBmcm9tIHVzZXJcbiIpKTsKQEAg
LTY3OSw3ICs2NzksNyBAQAogCQkJCXNnX2xpc3RbaV0gPSBwOyAvLyBzYXZlIHNvIHdlIGNhbiBj
bGVhbiB1cCBsYXRlcgogCQkJCXNnX2luZHggPSBpOwogCi0JCQkJaWYoIGZsYWdzICYgU1JCX0Rh
dGFPdXQgKXsKKwkJCQlpZiAoZmxhZ3MgJiBTUkJfRGF0YU91dCkgewogCQkJCQlpZihjb3B5X2Zy
b21fdXNlcihwLHNnX3VzZXJbaV0sdXNnLT5zZ1tpXS5jb3VudCkpewogCQkJCQkJZHByaW50aygo
S0VSTl9ERUJVRyJhYWNyYWlkOiBDb3VsZCBub3QgY29weSBzZyBkYXRhIGZyb20gdXNlclxuIikp
OwogCQkJCQkJcmNvZGUgPSAtRUZBVUxUOwpAQCAtNzA3LDcgKzcwNyw3IEBACiAJCQkJc2dfbGlz
dFtpXSA9IHA7IC8vIHNhdmUgc28gd2UgY2FuIGNsZWFuIHVwIGxhdGVyCiAJCQkJc2dfaW5keCA9
IGk7CiAKLQkJCQlpZiggZmxhZ3MgJiBTUkJfRGF0YU91dCApeworCQkJCWlmIChmbGFncyAmIFNS
Ql9EYXRhT3V0KSB7CiAJCQkJCWlmKGNvcHlfZnJvbV91c2VyKHAsIHNnX3VzZXJbaV0sCiAJCQkJ
CQkJdXBzZy0+c2dbaV0uY291bnQpKSB7CiAJCQkJCQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3Jh
aWQ6IENvdWxkIG5vdCBjb3B5IHNnIGRhdGEgZnJvbSB1c2VyXG4iKSk7CkBAIC03MzMsMTkgKzcz
MywxOSBAQAogCX0KIAogCWlmIChzdGF0dXMgIT0gMCl7Ci0JCWRwcmludGsoKEtFUk5fREVCVUci
YWFjcmFpZDogQ291bGQgbm90IHNlbmQgcmF3IHNyYiBmaWIgdG8gaGJhXG4iKSk7IAorCQlkcHJp
bnRrKChLRVJOX0RFQlVHImFhY3JhaWQ6IENvdWxkIG5vdCBzZW5kIHJhdyBzcmIgZmliIHRvIGhi
YVxuIikpOwogCQlyY29kZSA9IC1FTlhJTzsKIAkJZ290byBjbGVhbnVwOwogCX0KIAotCWlmKCBm
bGFncyAmIFNSQl9EYXRhSW4gKSB7CisJaWYgKGZsYWdzICYgU1JCX0RhdGFJbikgewogCQlmb3Io
aSA9IDAgOyBpIDw9IHNnX2luZHg7IGkrKyl7CiAJCQlieXRlX2NvdW50ID0gbGUzMl90b19jcHUo
CiAJCQkgIChkZXYtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09QVF9TR01BUF9IT1NUNjQp
CiAJCQkgICAgICA/ICgoc3RydWN0IHNnbWFwNjQqKSZzcmJjbWQtPnNnKS0+c2dbaV0uY291bnQK
IAkJCSAgICAgIDogc3JiY21kLT5zZy5zZ1tpXS5jb3VudCk7CiAJCQlpZihjb3B5X3RvX3VzZXIo
c2dfdXNlcltpXSwgc2dfbGlzdFtpXSwgYnl0ZV9jb3VudCkpewotCQkJCWRwcmludGsoKEtFUk5f
REVCVUciYWFjcmFpZDogQ291bGQgbm90IGNvcHkgc2cgZGF0YSB0byB1c2VyXG4iKSk7IAorCQkJ
CWRwcmludGsoKEtFUk5fREVCVUciYWFjcmFpZDogQ291bGQgbm90IGNvcHkgc2cgZGF0YSB0byB1
c2VyXG4iKSk7CiAJCQkJcmNvZGUgPSAtRUZBVUxUOwogCQkJCWdvdG8gY2xlYW51cDsKIApAQCAt
NzU1LDcgKzc1NSw3IEBACiAKIAlyZXBseSA9IChzdHJ1Y3QgYWFjX3NyYl9yZXBseSAqKSBmaWJf
ZGF0YShzcmJmaWIpOwogCWlmKGNvcHlfdG9fdXNlcih1c2VyX3JlcGx5LHJlcGx5LHNpemVvZihz
dHJ1Y3QgYWFjX3NyYl9yZXBseSkpKXsKLQkJZHByaW50aygoS0VSTl9ERUJVRyJhYWNyYWlkOiBD
b3VsZCBub3QgY29weSByZXBseSB0byB1c2VyXG4iKSk7IAorCQlkcHJpbnRrKChLRVJOX0RFQlVH
ImFhY3JhaWQ6IENvdWxkIG5vdCBjb3B5IHJlcGx5IHRvIHVzZXJcbiIpKTsKIAkJcmNvZGUgPSAt
RUZBVUxUOwogCQlnb3RvIGNsZWFudXA7CiAJfQpAQCAtNzc0LDM0ICs3NzQsMzQgQEAKIH0KIAog
c3RydWN0IGFhY19wY2lfaW5mbyB7Ci0gICAgICAgIHUzMiBidXM7Ci0gICAgICAgIHUzMiBzbG90
OworCXUzMiBidXM7CisJdTMyIHNsb3Q7CiB9OwogCiAKIHN0YXRpYyBpbnQgYWFjX2dldF9wY2lf
aW5mbyhzdHJ1Y3QgYWFjX2RldiogZGV2LCB2b2lkIF9fdXNlciAqYXJnKQogewotICAgICAgICBz
dHJ1Y3QgYWFjX3BjaV9pbmZvIHBjaV9pbmZvOworCXN0cnVjdCBhYWNfcGNpX2luZm8gcGNpX2lu
Zm87CiAKIAlwY2lfaW5mby5idXMgPSBkZXYtPnBkZXYtPmJ1cy0+bnVtYmVyOwogCXBjaV9pbmZv
LnNsb3QgPSBQQ0lfU0xPVChkZXYtPnBkZXYtPmRldmZuKTsKIAogICAgICAgIGlmIChjb3B5X3Rv
X3VzZXIoYXJnLCAmcGNpX2luZm8sIHNpemVvZihzdHJ1Y3QgYWFjX3BjaV9pbmZvKSkpIHsKLSAg
ICAgICAgICAgICAgIGRwcmludGsoKEtFUk5fREVCVUcgImFhY3JhaWQ6IENvdWxkIG5vdCBjb3B5
IHBjaSBpbmZvXG4iKSk7Ci0gICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsKKwkgICAgICAg
ZHByaW50aygoS0VSTl9ERUJVRyAiYWFjcmFpZDogQ291bGQgbm90IGNvcHkgcGNpIGluZm9cbiIp
KTsKKwkgICAgICAgcmV0dXJuIC1FRkFVTFQ7CiAJfQotICAgICAgICByZXR1cm4gMDsKKwlyZXR1
cm4gMDsKIH0KLSAKKwogCiBpbnQgYWFjX2RvX2lvY3RsKHN0cnVjdCBhYWNfZGV2ICogZGV2LCBp
bnQgY21kLCB2b2lkIF9fdXNlciAqYXJnKQogewogCWludCBzdGF0dXM7Ci0JCisKIAkvKgogCSAq
CUhCQSBnZXRzIGZpcnN0IGNyYWNrCiAJICovCi0JIAorCiAJc3RhdHVzID0gYWFjX2Rldl9pb2N0
bChkZXYsIGNtZCwgYXJnKTsKIAlpZihzdGF0dXMgIT0gLUVOT1RUWSkKIAkJcmV0dXJuIHN0YXR1
czsKQEAgLTgzMSw3ICs4MzEsNyBAQAogCQlicmVhazsKIAlkZWZhdWx0OgogCQlzdGF0dXMgPSAt
RU5PVFRZOwotCSAgCWJyZWFrOwkKKwkJYnJlYWs7CiAJfQogCXJldHVybiBzdGF0dXM7CiB9CmRp
ZmYgLXJ1IGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvY29tbXN1cC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1zdXAuYwkyMDA4
LTAxLTE2IDA5OjI4OjA4LjI0NjgzNTkzMCAtMDUwMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFp
ZC9jb21tc3VwLmMJMjAwOC0wMS0xNiAxMDowODo1Ny45MjU4NjQ2OTUgLTA1MDAKQEAgLTU2LDcg
KzU2LDcgQEAKICAqCUFsbG9jYXRlIGFuZCBtYXAgdGhlIHNoYXJlZCBQQ0kgc3BhY2UgZm9yIHRo
ZSBGSUIgYmxvY2tzIHVzZWQgdG8KICAqCXRhbGsgdG8gdGhlIEFkYXB0ZWMgZmlybXdhcmUuCiAg
Ki8KLSAKKwogc3RhdGljIGludCBmaWJfbWFwX2FsbG9jKHN0cnVjdCBhYWNfZGV2ICpkZXYpCiB7
CiAJZHByaW50aygoS0VSTl9JTkZPCkBAIC0xMDksMTQgKzEwOSwxNiBAQAogCX0KIAlpZiAoaTww
KQogCQlyZXR1cm4gLUVOT01FTTsKLQkJCisKIAlod19maWIgPSBkZXYtPmh3X2ZpYl92YTsKIAlo
d19maWJfcGEgPSBkZXYtPmh3X2ZpYl9wYTsKIAltZW1zZXQoaHdfZmliLCAwLCBkZXYtPm1heF9m
aWJfc2l6ZSAqIChkZXYtPnNjc2lfaG9zdF9wdHItPmNhbl9xdWV1ZSArIEFBQ19OVU1fTUdUX0ZJ
QikpOwogCS8qCiAJICoJSW5pdGlhbGlzZSB0aGUgZmlicwogCSAqLwotCWZvciAoaSA9IDAsIGZp
YnB0ciA9ICZkZXYtPmZpYnNbaV07IGkgPCAoZGV2LT5zY3NpX2hvc3RfcHRyLT5jYW5fcXVldWUg
KyBBQUNfTlVNX01HVF9GSUIpOyBpKyssIGZpYnB0cisrKSAKKwlmb3IgKGkgPSAwLCBmaWJwdHIg
PSAmZGV2LT5maWJzW2ldOworCQlpIDwgKGRldi0+c2NzaV9ob3N0X3B0ci0+Y2FuX3F1ZXVlICsg
QUFDX05VTV9NR1RfRklCKTsKKwkJaSsrLCBmaWJwdHIrKykKIAl7CiAJCWZpYnB0ci0+ZGV2ID0g
ZGV2OwogCQlmaWJwdHItPmh3X2ZpYl92YSA9IGh3X2ZpYjsKQEAgLTE0OCwxMyArMTUwLDEzIEBA
CiAgKglBbGxvY2F0ZSBhIGZpYiBmcm9tIHRoZSBhZGFwdGVyIGZpYiBwb29sLiBJZiB0aGUgcG9v
bCBpcyBlbXB0eSB3ZQogICoJcmV0dXJuIE5VTEwuCiAgKi8KLSAKKwogc3RydWN0IGZpYiAqYWFj
X2ZpYl9hbGxvYyhzdHJ1Y3QgYWFjX2RldiAqZGV2KQogewogCXN0cnVjdCBmaWIgKiBmaWJwdHI7
CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAlzcGluX2xvY2tfaXJxc2F2ZSgmZGV2LT5maWJfbG9j
aywgZmxhZ3MpOwotCWZpYnB0ciA9IGRldi0+ZnJlZV9maWI7CQorCWZpYnB0ciA9IGRldi0+ZnJl
ZV9maWI7CiAJaWYoIWZpYnB0cil7CiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldi0+Zmli
X2xvY2ssIGZsYWdzKTsKIAkJcmV0dXJuIGZpYnB0cjsKQEAgLTE4NCw3ICsxODYsNyBAQAogICoK
ICAqCUZyZWVzIHVwIGEgZmliIGFuZCBwbGFjZXMgaXQgb24gdGhlIGFwcHJvcHJpYXRlIHF1ZXVl
CiAgKi8KLSAKKwogdm9pZCBhYWNfZmliX2ZyZWUoc3RydWN0IGZpYiAqZmlicHRyKQogewogCXVu
c2lnbmVkIGxvbmcgZmxhZ3M7CkBAIC0yMDUsMTAgKzIwNywxMCBAQAogLyoqCiAgKglhYWNfZmli
X2luaXQJLQlpbml0aWFsaXNlIGEgZmliCiAgKglAZmlicHRyOiBUaGUgZmliIHRvIGluaXRpYWxp
emUKLSAqCQorICoKICAqCVNldCB1cCB0aGUgZ2VuZXJpYyBmaWIgZmllbGRzIHJlYWR5IGZvciB1
c2UKICAqLwotIAorCiB2b2lkIGFhY19maWJfaW5pdChzdHJ1Y3QgZmliICpmaWJwdHIpCiB7CiAJ
c3RydWN0IGh3X2ZpYiAqaHdfZmliID0gZmlicHRyLT5od19maWJfdmE7CkBAIC0yMjgsMTIgKzIz
MCwxMiBAQAogICoJV2lsbCBkZWFsbG9jYXRlIGFuZCByZXR1cm4gdG8gdGhlIGZyZWUgcG9vbCB0
aGUgRklCIHBvaW50ZWQgdG8gYnkgdGhlCiAgKgljYWxsZXIuCiAgKi8KLSAKKwogc3RhdGljIHZv
aWQgZmliX2RlYWxsb2Moc3RydWN0IGZpYiAqIGZpYnB0cikKIHsKIAlzdHJ1Y3QgaHdfZmliICpo
d19maWIgPSBmaWJwdHItPmh3X2ZpYl92YTsKIAlCVUdfT04oaHdfZmliLT5oZWFkZXIuU3RydWN0
VHlwZSAhPSBGSUJfTUFHSUMpOwotCWh3X2ZpYi0+aGVhZGVyLlhmZXJTdGF0ZSA9IDA7ICAgICAg
ICAKKwlod19maWItPmhlYWRlci5YZmVyU3RhdGUgPSAwOwogfQogCiAvKgpAQCAtMjQyLDcgKzI0
NCw3IEBACiAgKgl0aGVzZSByb3V0aW5lcyBhbmQgYXJlIHRoZSBvbmx5IHJvdXRpbmVzIHdoaWNo
IGhhdmUgYSBrbm93bGVkZ2Ugb2YgdGhlCiAgKgkgaG93IHRoZXNlIHF1ZXVlcyBhcmUgaW1wbGVt
ZW50ZWQuCiAgKi8KLSAKKwogLyoqCiAgKglhYWNfZ2V0X2VudHJ5CQktCWdldCBhIHF1ZXVlIGVu
dHJ5CiAgKglAZGV2OiBBZGFwdGVyCkBAIC0yNTUsNyArMjU3LDcgQEAKICAqCWlzIGZ1bGwobm8g
ZnJlZSBlbnRyaWVzKSB0aGFuIG5vIGVudHJ5IGlzIHJldHVybmVkIGFuZCB0aGUgZnVuY3Rpb24g
cmV0dXJucyAwIG90aGVyd2lzZSAxIGlzCiAgKglyZXR1cm5lZC4KICAqLwotIAorCiBzdGF0aWMg
aW50IGFhY19nZXRfZW50cnkgKHN0cnVjdCBhYWNfZGV2ICogZGV2LCB1MzIgcWlkLCBzdHJ1Y3Qg
YWFjX2VudHJ5ICoqZW50cnksIHUzMiAqIGluZGV4LCB1bnNpZ25lZCBsb25nICpub25vdGlmeSkK
IHsKIAlzdHJ1Y3QgYWFjX3F1ZXVlICogcTsKQEAgLTI4MCwyNiArMjgyLDI3IEBACiAJCQkJaWR4
ID0gQURBUF9OT1JNX1JFU1BfRU5UUklFUzsKIAkJfQogCQlpZiAoaWR4ICE9IGxlMzJfdG9fY3B1
KCoocS0+aGVhZGVycy5jb25zdW1lcikpKQotCQkJKm5vbm90aWZ5ID0gMTsgCisJCQkqbm9ub3Rp
ZnkgPSAxOwogCX0KIAogCWlmIChxaWQgPT0gQWRhcE5vcm1DbWRRdWV1ZSkgewotCSAgICAgICAg
aWYgKCppbmRleCA+PSBBREFQX05PUk1fQ01EX0VOVFJJRVMpIAorCQlpZiAoKmluZGV4ID49IEFE
QVBfTk9STV9DTURfRU5UUklFUykKIAkJCSppbmRleCA9IDA7IC8qIFdyYXAgdG8gZnJvbnQgb2Yg
dGhlIFByb2R1Y2VyIFF1ZXVlLiAqLwogCX0gZWxzZSB7Ci0JCWlmICgqaW5kZXggPj0gQURBUF9O
T1JNX1JFU1BfRU5UUklFUykgCisJCWlmICgqaW5kZXggPj0gQURBUF9OT1JNX1JFU1BfRU5UUklF
UykKIAkJCSppbmRleCA9IDA7IC8qIFdyYXAgdG8gZnJvbnQgb2YgdGhlIFByb2R1Y2VyIFF1ZXVl
LiAqLwogCX0KIAotICAgICAgICBpZiAoKCppbmRleCArIDEpID09IGxlMzJfdG9fY3B1KCoocS0+
aGVhZGVycy5jb25zdW1lcikpKSB7IC8qIFF1ZXVlIGlzIGZ1bGwgKi8KKwkvKiBRdWV1ZSBpcyBm
dWxsICovCisJaWYgKCgqaW5kZXggKyAxKSA9PSBsZTMyX3RvX2NwdSgqKHEtPmhlYWRlcnMuY29u
c3VtZXIpKSkgewogCQlwcmludGsoS0VSTl9XQVJOSU5HICJRdWV1ZSAlZCBmdWxsLCAldSBvdXRz
dGFuZGluZy5cbiIsCiAJCQkJcWlkLCBxLT5udW1wZW5kaW5nKTsKIAkJcmV0dXJuIDA7CiAJfSBl
bHNlIHsKLQkgICAgICAgICplbnRyeSA9IHEtPmJhc2UgKyAqaW5kZXg7CisJCSplbnRyeSA9IHEt
PmJhc2UgKyAqaW5kZXg7CiAJCXJldHVybiAxOwogCX0KLX0gICAKK30KIAogLyoqCiAgKglhYWNf
cXVldWVfZ2V0CQktCWdldCB0aGUgbmV4dCBmcmVlIFFFCkBAIC0zMjEsMzEgKzMyNCwzMSBAQAog
ewogCXN0cnVjdCBhYWNfZW50cnkgKiBlbnRyeSA9IE5VTEw7CiAJaW50IG1hcCA9IDA7Ci0JICAg
IAorCiAJaWYgKHFpZCA9PSBBZGFwTm9ybUNtZFF1ZXVlKSB7CiAJCS8qICBpZiBubyBlbnRyaWVz
IHdhaXQgZm9yIHNvbWUgaWYgY2FsbGVyIHdhbnRzIHRvICovCi0gICAgICAgIAl3aGlsZSAoIWFh
Y19nZXRfZW50cnkoZGV2LCBxaWQsICZlbnRyeSwgaW5kZXgsIG5vbm90aWZ5KSkgCi0gICAgICAg
IAl7CisJCXdoaWxlICghYWFjX2dldF9lbnRyeShkZXYsIHFpZCwgJmVudHJ5LCBpbmRleCwgbm9u
b3RpZnkpKQorCQl7CiAJCQlwcmludGsoS0VSTl9FUlIgIkdldEVudHJpZXMgZmFpbGVkXG4iKTsK
IAkJfQotCSAgICAgICAgLyoKLQkgICAgICAgICAqCVNldHVwIHF1ZXVlIGVudHJ5IHdpdGggYSBj
b21tYW5kLCBzdGF0dXMgYW5kIGZpYiBtYXBwZWQKLQkgICAgICAgICAqLwotCSAgICAgICAgZW50
cnktPnNpemUgPSBjcHVfdG9fbGUzMihsZTE2X3RvX2NwdShod19maWItPmhlYWRlci5TaXplKSk7
Ci0JICAgICAgICBtYXAgPSAxOworCQkvKgorCQkgKglTZXR1cCBxdWV1ZSBlbnRyeSB3aXRoIGEg
Y29tbWFuZCwgc3RhdHVzIGFuZCBmaWIgbWFwcGVkCisJCSAqLworCQllbnRyeS0+c2l6ZSA9IGNw
dV90b19sZTMyKGxlMTZfdG9fY3B1KGh3X2ZpYi0+aGVhZGVyLlNpemUpKTsKKwkJbWFwID0gMTsK
IAl9IGVsc2UgewotCSAgICAgICAgd2hpbGUoIWFhY19nZXRfZW50cnkoZGV2LCBxaWQsICZlbnRy
eSwgaW5kZXgsIG5vbm90aWZ5KSkgCi0JICAgICAgICB7CisJCXdoaWxlKCFhYWNfZ2V0X2VudHJ5
KGRldiwgcWlkLCAmZW50cnksIGluZGV4LCBub25vdGlmeSkpCisJCXsKIAkJCS8qIGlmIG5vIGVu
dHJpZXMgd2FpdCBmb3Igc29tZSBpZiBjYWxsZXIgd2FudHMgdG8gKi8KIAkJfQotICAgICAgICAJ
LyoKLSAgICAgICAgCSAqCVNldHVwIHF1ZXVlIGVudHJ5IHdpdGggY29tbWFuZCwgc3RhdHVzIGFu
ZCBmaWIgbWFwcGVkCi0gICAgICAgIAkgKi8KLSAgICAgICAgCWVudHJ5LT5zaXplID0gY3B1X3Rv
X2xlMzIobGUxNl90b19jcHUoaHdfZmliLT5oZWFkZXIuU2l6ZSkpOwotICAgICAgICAJZW50cnkt
PmFkZHIgPSBod19maWItPmhlYWRlci5TZW5kZXJGaWJBZGRyZXNzOwotICAgICAJCQkvKiBSZXN0
b3JlIGFkYXB0ZXJzIHBvaW50ZXIgdG8gdGhlIEZJQiAqLworCQkvKgorCQkgKglTZXR1cCBxdWV1
ZSBlbnRyeSB3aXRoIGNvbW1hbmQsIHN0YXR1cyBhbmQgZmliIG1hcHBlZAorCQkgKi8KKwkJZW50
cnktPnNpemUgPSBjcHVfdG9fbGUzMihsZTE2X3RvX2NwdShod19maWItPmhlYWRlci5TaXplKSk7
CisJCWVudHJ5LT5hZGRyID0gaHdfZmliLT5oZWFkZXIuU2VuZGVyRmliQWRkcmVzczsKKwkJCS8q
IFJlc3RvcmUgYWRhcHRlcnMgcG9pbnRlciB0byB0aGUgRklCICovCiAJCWh3X2ZpYi0+aGVhZGVy
LlJlY2VpdmVyRmliQWRkcmVzcyA9IGh3X2ZpYi0+aGVhZGVyLlNlbmRlckZpYkFkZHJlc3M7CS8q
IExldCB0aGUgYWRhcHRlciBub3cgd2hlcmUgdG8gZmluZCBpdHMgZGF0YSAqLwotICAgICAgICAJ
bWFwID0gMDsKKwkJbWFwID0gMDsKIAl9CiAJLyoKIAkgKglJZiBNYXBGaWIgaXMgdHJ1ZSB0aGFu
IHdlIG5lZWQgdG8gbWFwIHRoZSBGaWIgYW5kIHB1dCBwb2ludGVycwpAQCAtMzU3LDggKzM2MCw4
IEBACiB9CiAKIC8qCi0gKglEZWZpbmUgdGhlIGhpZ2hlc3QgbGV2ZWwgb2YgaG9zdCB0byBhZGFw
dGVyIGNvbW11bmljYXRpb24gcm91dGluZXMuIAotICoJVGhlc2Ugcm91dGluZXMgd2lsbCBzdXBw
b3J0IGhvc3QgdG8gYWRhcHRlciBGUyBjb21tdWljYXRpb24uIFRoZXNlIAorICoJRGVmaW5lIHRo
ZSBoaWdoZXN0IGxldmVsIG9mIGhvc3QgdG8gYWRhcHRlciBjb21tdW5pY2F0aW9uIHJvdXRpbmVz
LgorICoJVGhlc2Ugcm91dGluZXMgd2lsbCBzdXBwb3J0IGhvc3QgdG8gYWRhcHRlciBGUyBjb21t
dWljYXRpb24uIFRoZXNlCiAgKglyb3V0aW5lcyBoYXZlIG5vIGtub3dsZWRnZSBvZiB0aGUgY29t
bXVpY2F0aW9uIG1ldGhvZCB1c2VkLiBUaGlzIGxldmVsCiAgKglzZW5kcyBhbmQgcmVjZWl2ZXMg
RklCcy4gVGhpcyBsZXZlbCBoYXMgbm8ga25vd2xlZGdlIG9mIGhvdyB0aGVzZSBGSUJzCiAgKgln
ZXQgcGFzc2VkIGJhY2sgYW5kIGZvcnRoLgpAQCAtMzgwLDcgKzM4Myw3IEBACiAgKglhbiBldmVu
dCB0byB3YWl0IG9uIG11c3QgYmUgc3VwcGxpZWQuIFRoaXMgZXZlbnQgd2lsbCBiZSBzZXQgd2hl
biBhCiAgKglyZXNwb25zZSBGSUIgaXMgcmVjZWl2ZWQgZnJvbSB0aGUgYWRhcHRlci4KICAqLwot
IAorCiBpbnQgYWFjX2ZpYl9zZW5kKHUxNiBjb21tYW5kLCBzdHJ1Y3QgZmliICpmaWJwdHIsIHVu
c2lnbmVkIGxvbmcgc2l6ZSwKIAkJaW50IHByaW9yaXR5LCBpbnQgd2FpdCwgaW50IHJlcGx5LCBm
aWJfY2FsbGJhY2sgY2FsbGJhY2ssCiAJCXZvaWQgKmNhbGxiYWNrX2RhdGEpCkBAIC0zOTMsMTMg
KzM5NiwxMyBAQAogCWlmICghKGh3X2ZpYi0+aGVhZGVyLlhmZXJTdGF0ZSAmIGNwdV90b19sZTMy
KEhvc3RPd25lZCkpKQogCQlyZXR1cm4gLUVCVVNZOwogCS8qCi0JICoJVGhlcmUgYXJlIDUgY2Fz
ZXMgd2l0aCB0aGUgd2FpdCBhbmQgcmVwb25zZSByZXF1ZXN0ZWQgZmxhZ3MuIAorCSAqCVRoZXJl
IGFyZSA1IGNhc2VzIHdpdGggdGhlIHdhaXQgYW5kIHJlcG9uc2UgcmVxdWVzdGVkIGZsYWdzLgog
CSAqCVRoZSBvbmx5IGludmFsaWQgY2FzZXMgYXJlIGlmIHRoZSBjYWxsZXIgcmVxdWVzdHMgdG8g
d2FpdCBhbmQKIAkgKglkb2VzIG5vdCByZXF1ZXN0IGEgcmVzcG9uc2UgYW5kIGlmIHRoZSBjYWxs
ZXIgZG9lcyBub3Qgd2FudCBhCiAJICoJcmVzcG9uc2UgYW5kIHRoZSBGaWIgaXMgbm90IGFsbG9j
YXRlZCBmcm9tIHBvb2wuIElmIGEgcmVzcG9uc2UKIAkgKglpcyBub3QgcmVxdWVzZWQgdGhlIEZp
YiB3aWxsIGp1c3QgYmUgZGVhbGxvY2FlZCBieSB0aGUgRFBDCiAJICoJcm91dGluZSB3aGVuIHRo
ZSByZXNwb25zZSBjb21lcyBiYWNrIGZyb20gdGhlIGFkYXB0ZXIuIE5vCi0JICoJZnVydGhlciBw
cm9jZXNzaW5nIHdpbGwgYmUgZG9uZSBiZXNpZGVzIGRlbGV0aW5nIHRoZSBGaWIuIFdlIAorCSAq
CWZ1cnRoZXIgcHJvY2Vzc2luZyB3aWxsIGJlIGRvbmUgYmVzaWRlcyBkZWxldGluZyB0aGUgRmli
LiBXZQogCSAqCXdpbGwgaGF2ZSBhIGRlYnVnIG1vZGUgd2hlcmUgdGhlIGFkYXB0ZXIgY2FuIG5v
dGlmeSB0aGUgaG9zdAogCSAqCWl0IGhhZCBhIHByb2JsZW0gYW5kIHRoZSBob3N0IGNhbiBsb2cg
dGhhdCBmYWN0LgogCSAqLwpAQCAtNDE1LDcgKzQxOCw3IEBACiAJfSBlbHNlIGlmICh3YWl0ICYm
IHJlcGx5KSB7CiAJCWh3X2ZpYi0+aGVhZGVyLlhmZXJTdGF0ZSB8PSBjcHVfdG9fbGUzMihSZXNw
b25zZUV4cGVjdGVkKTsKIAkJRklCX0NPVU5URVJfSU5DUkVNRU5UKGFhY19jb25maWcuTm9ybWFs
U2VudCk7Ci0JfSAKKwl9CiAJLyoKIAkgKglNYXAgdGhlIGZpYiBpbnRvIDMyYml0cyBieSB1c2lu
ZyB0aGUgZmliIG51bWJlcgogCSAqLwpAQCAtNDM4LDcgKzQ0MSw3IEBACiAJaHdfZmliLT5oZWFk
ZXIuU2l6ZSA9IGNwdV90b19sZTE2KHNpemVvZihzdHJ1Y3QgYWFjX2ZpYmhkcikgKyBzaXplKTsK
IAlpZiAobGUxNl90b19jcHUoaHdfZmliLT5oZWFkZXIuU2l6ZSkgPiBsZTE2X3RvX2NwdShod19m
aWItPmhlYWRlci5TZW5kZXJTaXplKSkgewogCQlyZXR1cm4gLUVNU0dTSVpFOwotCX0gICAgICAg
ICAgICAgICAgCisJfQogCS8qCiAJICoJR2V0IGEgcXVldWUgZW50cnkgY29ubmVjdCB0aGUgRklC
IHRvIGl0IGFuZCBzZW5kIGFuIG5vdGlmeQogCSAqCXRoZSBhZGFwdGVyIGEgY29tbWFuZCBpcyBy
ZWFkeS4KQEAgLTQ3NSw5ICs0NzgsOSBAQAogCWFhY19hZGFwdGVyX2RlbGl2ZXIoZmlicHRyKTsK
IAogCS8qCi0JICoJSWYgdGhlIGNhbGxlciB3YW50ZWQgdXMgdG8gd2FpdCBmb3IgcmVzcG9uc2Ug
d2FpdCBub3cuIAorCSAqCUlmIHRoZSBjYWxsZXIgd2FudGVkIHVzIHRvIHdhaXQgZm9yIHJlc3Bv
bnNlIHdhaXQgbm93LgogCSAqLwotICAgIAorCiAJaWYgKHdhaXQpIHsKIAkJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmZmlicHRyLT5ldmVudF9sb2NrLCBmbGFncyk7CiAJCS8qIE9ubHkgc2V0IGZv
ciBmaXJzdCBrbm93biBpbnRlcnJ1cHRhYmxlIGNvbW1hbmQgKi8KQEAgLTUyNCw3ICs1MjcsNyBA
QAogCQl9CiAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmZpYnB0ci0+ZXZlbnRfbG9jaywgZmxh
Z3MpOwogCQlCVUdfT04oZmlicHRyLT5kb25lID09IDApOwotCQkJCisKIAkJaWYodW5saWtlbHko
ZmlicHRyLT5mbGFncyAmIEZJQl9DT05URVhUX0ZMQUdfVElNRURfT1VUKSkKIAkJCXJldHVybiAt
RVRJTUVET1VUOwogCQlyZXR1cm4gMDsKQEAgLTUzOSwxNSArNTQyLDE1IEBACiAJCXJldHVybiAw
OwogfQogCi0vKiogCisvKioKICAqCWFhY19jb25zdW1lcl9nZXQJLQlnZXQgdGhlIHRvcCBvZiB0
aGUgcXVldWUKICAqCUBkZXY6IEFkYXB0ZXIKICAqCUBxOiBRdWV1ZQogICoJQGVudHJ5OiBSZXR1
cm4gZW50cnkKICAqCiAgKglXaWxsIHJldHVybiBhIHBvaW50ZXIgdG8gdGhlIGVudHJ5IG9uIHRo
ZSB0b3Agb2YgdGhlIHF1ZXVlIHJlcXVlc3RlZCB0aGF0Ci0gKiAJd2UgYXJlIGEgY29uc3VtZXIg
b2YsIGFuZCByZXR1cm4gdGhlIGFkZHJlc3Mgb2YgdGhlIHF1ZXVlIGVudHJ5LiBJdCBkb2VzCi0g
Kglub3QgY2hhbmdlIHRoZSBzdGF0ZSBvZiB0aGUgcXVldWUuIAorICoJd2UgYXJlIGEgY29uc3Vt
ZXIgb2YsIGFuZCByZXR1cm4gdGhlIGFkZHJlc3Mgb2YgdGhlIHF1ZXVlIGVudHJ5LiBJdCBkb2Vz
CisgKglub3QgY2hhbmdlIHRoZSBzdGF0ZSBvZiB0aGUgcXVldWUuCiAgKi8KIAogaW50IGFhY19j
b25zdW1lcl9nZXQoc3RydWN0IGFhY19kZXYgKiBkZXYsIHN0cnVjdCBhYWNfcXVldWUgKiBxLCBz
dHJ1Y3QgYWFjX2VudHJ5ICoqZW50cnkpCkBAIC01NjIsMTAgKzU2NSwxMCBAQAogCQkgKgl0aGUg
ZW5kIG9mIHRoZSBxdWV1ZSwgZWxzZSB3ZSBqdXN0IHVzZSB0aGUgZW50cnkKIAkJICoJcG9pbnRl
ZCB0byBieSB0aGUgaGVhZGVyIGluZGV4CiAJCSAqLwotCQlpZiAobGUzMl90b19jcHUoKnEtPmhl
YWRlcnMuY29uc3VtZXIpID49IHEtPmVudHJpZXMpIAotCQkJaW5kZXggPSAwOwkJCisJCWlmIChs
ZTMyX3RvX2NwdSgqcS0+aGVhZGVycy5jb25zdW1lcikgPj0gcS0+ZW50cmllcykKKwkJCWluZGV4
ID0gMDsKIAkJZWxzZQotCQkgICAgICAgIGluZGV4ID0gbGUzMl90b19jcHUoKnEtPmhlYWRlcnMu
Y29uc3VtZXIpOworCQkJaW5kZXggPSBsZTMyX3RvX2NwdSgqcS0+aGVhZGVycy5jb25zdW1lcik7
CiAJCSplbnRyeSA9IHEtPmJhc2UgKyBpbmRleDsKIAkJc3RhdHVzID0gMTsKIAl9CkBAIC01ODks
MTIgKzU5MiwxMiBAQAogCiAJaWYgKChsZTMyX3RvX2NwdSgqcS0+aGVhZGVycy5wcm9kdWNlcikr
MSkgPT0gbGUzMl90b19jcHUoKnEtPmhlYWRlcnMuY29uc3VtZXIpKQogCQl3YXNmdWxsID0gMTsK
LSAgICAgICAgCisKIAlpZiAobGUzMl90b19jcHUoKnEtPmhlYWRlcnMuY29uc3VtZXIpID49IHEt
PmVudHJpZXMpCiAJCSpxLT5oZWFkZXJzLmNvbnN1bWVyID0gY3B1X3RvX2xlMzIoMSk7CiAJZWxz
ZQogCQkqcS0+aGVhZGVycy5jb25zdW1lciA9IGNwdV90b19sZTMyKGxlMzJfdG9fY3B1KCpxLT5o
ZWFkZXJzLmNvbnN1bWVyKSsxKTsKLSAgICAgICAgCisKIAlpZiAod2FzZnVsbCkgewogCQlzd2l0
Y2ggKHFpZCkgewogCkBAIC02MTAsNyArNjEzLDcgQEAKIAkJfQogCQlhYWNfYWRhcHRlcl9ub3Rp
ZnkoZGV2LCBub3RpZnkpOwogCX0KLX0gICAgICAgIAorfQogCiAvKioKICAqCWFhY19maWJfYWRh
cHRlcl9jb21wbGV0ZQktCWNvbXBsZXRlIGFkYXB0ZXIgaXNzdWVkIGZpYgpAQCAtNjMyLDMyICs2
MzUsMzIgQEAKIAlpZiAoaHdfZmliLT5oZWFkZXIuWGZlclN0YXRlID09IDApIHsKIAkJaWYgKGRl
di0+Y29tbV9pbnRlcmZhY2UgPT0gQUFDX0NPTU1fTUVTU0FHRSkKIAkJCWtmcmVlIChod19maWIp
OwotICAgICAgICAJcmV0dXJuIDA7CisJCXJldHVybiAwOwogCX0KIAkvKgogCSAqCUlmIHdlIHBs
YW4gdG8gZG8gYW55dGhpbmcgY2hlY2sgdGhlIHN0cnVjdHVyZSB0eXBlIGZpcnN0LgotCSAqLyAK
LQlpZiAoIGh3X2ZpYi0+aGVhZGVyLlN0cnVjdFR5cGUgIT0gRklCX01BR0lDICkgeworCSAqLwor
CWlmIChod19maWItPmhlYWRlci5TdHJ1Y3RUeXBlICE9IEZJQl9NQUdJQykgewogCQlpZiAoZGV2
LT5jb21tX2ludGVyZmFjZSA9PSBBQUNfQ09NTV9NRVNTQUdFKQogCQkJa2ZyZWUgKGh3X2ZpYik7
Ci0gICAgICAgIAlyZXR1cm4gLUVJTlZBTDsKKwkJcmV0dXJuIC1FSU5WQUw7CiAJfQogCS8qCiAJ
ICoJVGhpcyBibG9jayBoYW5kbGVzIHRoZSBjYXNlIHdoZXJlIHRoZSBhZGFwdGVyIGhhZCBzZW50
IHVzIGEKIAkgKgljb21tYW5kIGFuZCB3ZSBoYXZlIGZpbmlzaGVkIHByb2Nlc3NpbmcgdGhlIGNv
bW1hbmQuIFdlCi0JICoJY2FsbCBjb21wbGV0ZUZpYiB3aGVuIHdlIGFyZSBkb25lIHByb2Nlc3Np
bmcgdGhlIGNvbW1hbmQgCi0JICoJYW5kIHdhbnQgdG8gc2VuZCBhIHJlc3BvbnNlIGJhY2sgdG8g
dGhlIGFkYXB0ZXIuIFRoaXMgd2lsbCAKKwkgKgljYWxsIGNvbXBsZXRlRmliIHdoZW4gd2UgYXJl
IGRvbmUgcHJvY2Vzc2luZyB0aGUgY29tbWFuZAorCSAqCWFuZCB3YW50IHRvIHNlbmQgYSByZXNw
b25zZSBiYWNrIHRvIHRoZSBhZGFwdGVyLiBUaGlzIHdpbGwKIAkgKglzZW5kIHRoZSBjb21wbGV0
ZWQgY2RiIHRvIHRoZSBhZGFwdGVyLgogCSAqLwogCWlmIChod19maWItPmhlYWRlci5YZmVyU3Rh
dGUgJiBjcHVfdG9fbGUzMihTZW50RnJvbUFkYXB0ZXIpKSB7CiAJCWlmIChkZXYtPmNvbW1faW50
ZXJmYWNlID09IEFBQ19DT01NX01FU1NBR0UpIHsKIAkJCWtmcmVlIChod19maWIpOwogCQl9IGVs
c2UgewotCSAgICAgICAJCXUzMiBpbmRleDsKLQkJICAgICAgICBod19maWItPmhlYWRlci5YZmVy
U3RhdGUgfD0gY3B1X3RvX2xlMzIoSG9zdFByb2Nlc3NlZCk7CisJCQl1MzIgaW5kZXg7CisJCQlo
d19maWItPmhlYWRlci5YZmVyU3RhdGUgfD0gY3B1X3RvX2xlMzIoSG9zdFByb2Nlc3NlZCk7CiAJ
CQlpZiAoc2l6ZSkgewogCQkJCXNpemUgKz0gc2l6ZW9mKHN0cnVjdCBhYWNfZmliaGRyKTsKLQkJ
CQlpZiAoc2l6ZSA+IGxlMTZfdG9fY3B1KGh3X2ZpYi0+aGVhZGVyLlNlbmRlclNpemUpKSAKKwkJ
CQlpZiAoc2l6ZSA+IGxlMTZfdG9fY3B1KGh3X2ZpYi0+aGVhZGVyLlNlbmRlclNpemUpKQogCQkJ
CQlyZXR1cm4gLUVNU0dTSVpFOwogCQkJCWh3X2ZpYi0+aGVhZGVyLlNpemUgPSBjcHVfdG9fbGUx
NihzaXplKTsKIAkJCX0KQEAgLTY3MCwxMSArNjczLDEyIEBACiAJCQkJYWFjX2FkYXB0ZXJfbm90
aWZ5KGRldiwgQWRhcE5vcm1SZXNwUXVldWUpOwogCQl9CiAJfQotCWVsc2UgCisJZWxzZQogCXsK
LSAgICAgICAgCXByaW50ayhLRVJOX1dBUk5JTkcgImFhY19maWJfYWRhcHRlcl9jb21wbGV0ZTog
VW5rbm93biB4ZmVyc3RhdGUgZGV0ZWN0ZWQuXG4iKTsKLSAgICAgICAgCUJVRygpOwotCX0gICAK
KwkJcHJpbnRrKEtFUk5fV0FSTklORyAiYWFjX2ZpYl9hZGFwdGVyX2NvbXBsZXRlOiAiCisJCQki
VW5rbm93biB4ZmVyc3RhdGUgZGV0ZWN0ZWQuXG4iKTsKKwkJQlVHKCk7CisJfQogCXJldHVybiAw
OwogfQogCkBAIC02ODQsNyArNjg4LDcgQEAKICAqCiAgKglXaWxsIGRvIGFsbCBuZWNlc3Nhcnkg
d29yayB0byBjb21wbGV0ZSBhIEZJQi4KICAqLwotIAorCiBpbnQgYWFjX2ZpYl9jb21wbGV0ZShz
dHJ1Y3QgZmliICpmaWJwdHIpCiB7CiAJc3RydWN0IGh3X2ZpYiAqIGh3X2ZpYiA9IGZpYnB0ci0+
aHdfZmliX3ZhOwpAQCAtNjk0LDE1ICs2OTgsMTUgQEAKIAkgKi8KIAogCWlmIChod19maWItPmhl
YWRlci5YZmVyU3RhdGUgPT0gMCkKLSAgICAgICAgCXJldHVybiAwOworCQlyZXR1cm4gMDsKIAkv
KgogCSAqCUlmIHdlIHBsYW4gdG8gZG8gYW55dGhpbmcgY2hlY2sgdGhlIHN0cnVjdHVyZSB0eXBl
IGZpcnN0LgotCSAqLyAKKwkgKi8KIAogCWlmIChod19maWItPmhlYWRlci5TdHJ1Y3RUeXBlICE9
IEZJQl9NQUdJQykKLQkgICAgICAgIHJldHVybiAtRUlOVkFMOworCQlyZXR1cm4gLUVJTlZBTDsK
IAkvKgotCSAqCVRoaXMgYmxvY2sgY29tcGxldGVzIGEgY2RiIHdoaWNoIG9yZ2luYXRlZCBvbiB0
aGUgaG9zdCBhbmQgd2UgCisJICoJVGhpcyBibG9jayBjb21wbGV0ZXMgYSBjZGIgd2hpY2ggb3Jn
aW5hdGVkIG9uIHRoZSBob3N0IGFuZCB3ZQogCSAqCWp1c3QgbmVlZCB0byBkZWFsbG9jYXRlIHRo
ZSBjZGIgb3IgcmVpbml0IGl0LiBBdCB0aGlzIHBvaW50IHRoZQogCSAqCWNvbW1hbmQgaXMgY29t
cGxldGUgdGhhdCB3ZSBoYWQgc2VudCB0byB0aGUgYWRhcHRlciBhbmQgdGhpcwogCSAqCWNkYiBj
b3VsZCBiZSByZXVzZWQuCkBAIC03MjMsNyArNzI3LDcgQEAKIAkJZmliX2RlYWxsb2MoZmlicHRy
KTsKIAl9IGVsc2UgewogCQlCVUcoKTsKLQl9ICAgCisJfQogCXJldHVybiAwOwogfQogCkBAIC03
NDMsNyArNzQ3LDcgQEAKIAl7CiAJCWludCBsZW5ndGggPSB2YWwgJiAweGZmZmY7CiAJCWludCBs
ZXZlbCA9ICh2YWwgPj4gMTYpICYgMHhmZmZmOwotCQkKKwogCQkvKgogCQkgKglUaGUgc2l6ZSBv
ZiB0aGUgcHJpbnRmYnVmIGlzIHNldCBpbiBwb3J0LmMKIAkJICoJVGhlcmUgaXMgbm8gdmFyaWFi
bGUgb3IgZGVmaW5lIGZvciBpdApAQCAtNzU3LDcgKzc2MSw3IEBACiAJCWVsc2UKIAkJCXByaW50
ayhLRVJOX0lORk8gIiVzOiVzIiwgZGV2LT5uYW1lLCBjcCk7CiAJfQotCW1lbXNldChjcCwgMCwg
IDI1Nik7CisJbWVtc2V0KGNwLCAwLCAyNTYpOwogfQogCiAKQEAgLTgxNiw5ICs4MjAsOSBAQAog
CQkJICovCiAKIAkJCWlmICgoZGV2ICE9IE5VTEwpICYmIChkZXYtPnNjc2lfaG9zdF9wdHIgIT0g
TlVMTCkpIHsKLQkJCQlkZXZpY2UgPSBzY3NpX2RldmljZV9sb29rdXAoZGV2LT5zY3NpX2hvc3Rf
cHRyLCAKLQkJCQkJQ09OVEFJTkVSX1RPX0NIQU5ORUwoY29udGFpbmVyKSwgCi0JCQkJCUNPTlRB
SU5FUl9UT19JRChjb250YWluZXIpLCAKKwkJCQlkZXZpY2UgPSBzY3NpX2RldmljZV9sb29rdXAo
ZGV2LT5zY3NpX2hvc3RfcHRyLAorCQkJCQlDT05UQUlORVJfVE9fQ0hBTk5FTChjb250YWluZXIp
LAorCQkJCQlDT05UQUlORVJfVE9fSUQoY29udGFpbmVyKSwKIAkJCQkJQ09OVEFJTkVSX1RPX0xV
Tihjb250YWluZXIpKTsKIAkJCQlpZiAoZGV2aWNlKSB7CiAJCQkJCWRldi0+ZnNhX2Rldltjb250
YWluZXJdLmNvbmZpZ19uZWVkZWQgPSBDSEFOR0U7CkBAIC0xMTg0LDEzICsxMTg4LDEzIEBACiAJ
fQogCSh2b2lkKWFhY19nZXRfYWRhcHRlcl9pbmZvKGFhYyk7CiAJaWYgKChxdWlya3MgJiBBQUNf
UVVJUktfMzRTRykgJiYgKGhvc3QtPnNnX3RhYmxlc2l6ZSA+IDM0KSkgewotIAkJaG9zdC0+c2df
dGFibGVzaXplID0gMzQ7Ci0gCQlob3N0LT5tYXhfc2VjdG9ycyA9IChob3N0LT5zZ190YWJsZXNp
emUgKiA4KSArIDExMjsKLSAJfQotIAlpZiAoKHF1aXJrcyAmIEFBQ19RVUlSS18xN1NHKSAmJiAo
aG9zdC0+c2dfdGFibGVzaXplID4gMTcpKSB7Ci0gCQlob3N0LT5zZ190YWJsZXNpemUgPSAxNzsK
LSAJCWhvc3QtPm1heF9zZWN0b3JzID0gKGhvc3QtPnNnX3RhYmxlc2l6ZSAqIDgpICsgMTEyOwot
IAl9CisJCWhvc3QtPnNnX3RhYmxlc2l6ZSA9IDM0OworCQlob3N0LT5tYXhfc2VjdG9ycyA9ICho
b3N0LT5zZ190YWJsZXNpemUgKiA4KSArIDExMjsKKwl9CisJaWYgKChxdWlya3MgJiBBQUNfUVVJ
UktfMTdTRykgJiYgKGhvc3QtPnNnX3RhYmxlc2l6ZSA+IDE3KSkgeworCQlob3N0LT5zZ190YWJs
ZXNpemUgPSAxNzsKKwkJaG9zdC0+bWF4X3NlY3RvcnMgPSAoaG9zdC0+c2dfdGFibGVzaXplICog
OCkgKyAxMTI7CisJfQogCWFhY19nZXRfY29uZmlnX3N0YXR1cyhhYWMsIDEpOwogCWFhY19nZXRf
Y29udGFpbmVycyhhYWMpOwogCS8qCkBAIC0xNDYxLDcgKzE0NjUsNyBAQAogICoJdW50aWwgdGhl
IHF1ZXVlIGlzIGVtcHR5LiBXaGVuIHRoZSBxdWV1ZSBpcyBlbXB0eSBpdCB3aWxsIHdhaXQgZm9y
CiAgKgltb3JlIEZJQnMuCiAgKi8KLSAKKwogaW50IGFhY19jb21tYW5kX3RocmVhZCh2b2lkICpk
YXRhKQogewogCXN0cnVjdCBhYWNfZGV2ICpkZXYgPSBkYXRhOwpAQCAtMTQ4Nyw3ICsxNDkxLDcg
QEAKIAlhZGRfd2FpdF9xdWV1ZSgmZGV2LT5xdWV1ZXMtPnF1ZXVlW0hvc3ROb3JtQ21kUXVldWVd
LmNtZHJlYWR5LCAmd2FpdCk7CiAJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19JTlRFUlJVUFRJQkxF
KTsKIAlkcHJpbnRrICgoS0VSTl9JTkZPICJhYWNfY29tbWFuZF90aHJlYWQgc3RhcnRcbiIpKTsK
LQl3aGlsZSgxKSAKKwl3aGlsZSgxKQogCXsKIAkJc3Bpbl9sb2NrX2lycXNhdmUoZGV2LT5xdWV1
ZXMtPnF1ZXVlW0hvc3ROb3JtQ21kUXVldWVdLmxvY2ssIGZsYWdzKTsKIAkJd2hpbGUoIWxpc3Rf
ZW1wdHkoJihkZXYtPnF1ZXVlcy0+cXVldWVbSG9zdE5vcm1DbWRRdWV1ZV0uY21kcSkpKSB7CkBA
IC0xNDk1LDIyICsxNDk5LDIyIEBACiAJCQlzdHJ1Y3QgYWFjX2FpZmNtZCAqIGFpZmNtZDsKIAog
CQkJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19SVU5OSU5HKTsKLQkKKwogCQkJZW50cnkgPSBkZXYt
PnF1ZXVlcy0+cXVldWVbSG9zdE5vcm1DbWRRdWV1ZV0uY21kcS5uZXh0OwogCQkJbGlzdF9kZWwo
ZW50cnkpOwotCQkKKwogCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShkZXYtPnF1ZXVlcy0+cXVl
dWVbSG9zdE5vcm1DbWRRdWV1ZV0ubG9jaywgZmxhZ3MpOwogCQkJZmliID0gbGlzdF9lbnRyeShl
bnRyeSwgc3RydWN0IGZpYiwgZmlibGluayk7CiAJCQkvKgotCQkJICoJV2Ugd2lsbCBwcm9jZXNz
IHRoZSBGSUIgaGVyZSBvciBwYXNzIGl0IHRvIGEgCi0JCQkgKgl3b3JrZXIgdGhyZWFkIHRoYXQg
aXMgVEJELiBXZSBSZWFsbHkgY2FuJ3QgCisJCQkgKglXZSB3aWxsIHByb2Nlc3MgdGhlIEZJQiBo
ZXJlIG9yIHBhc3MgaXQgdG8gYQorCQkJICoJd29ya2VyIHRocmVhZCB0aGF0IGlzIFRCRC4gV2Ug
UmVhbGx5IGNhbid0CiAJCQkgKglkbyBhbnl0aGluZyBhdCB0aGlzIHBvaW50IHNpbmNlIHdlIGRv
bid0IGhhdmUKIAkJCSAqCWFueXRoaW5nIGRlZmluZWQgZm9yIHRoaXMgdGhyZWFkIHRvIGRvLgog
CQkJICovCiAJCQlod19maWIgPSBmaWItPmh3X2ZpYl92YTsKIAkJCW1lbXNldChmaWIsIDAsIHNp
emVvZihzdHJ1Y3QgZmliKSk7CiAJCQlmaWItPnR5cGUgPSBGU0FGU19OVENfRklCX0NPTlRFWFQ7
Ci0JCQlmaWItPnNpemUgPSBzaXplb2YoIHN0cnVjdCBmaWIgKTsKKwkJCWZpYi0+c2l6ZSA9IHNp
emVvZihzdHJ1Y3QgZmliKTsKIAkJCWZpYi0+aHdfZmliX3ZhID0gaHdfZmliOwogCQkJZmliLT5k
YXRhID0gaHdfZmliLT5kYXRhOwogCQkJZmliLT5kZXYgPSBkZXY7CkBAIC0xNTI2LDE3ICsxNTMw
LDE3IEBACiAJCQl9IGVsc2UgewogCQkJCS8qIFRoZSB1MzIgaGVyZSBpcyBpbXBvcnRhbnQgYW5k
IGludGVuZGVkLiBXZSBhcmUgdXNpbmcKIAkJCQkgICAzMmJpdCB3cmFwcGluZyB0aW1lIHRvIGZp
dCB0aGUgYWRhcHRlciBmaWVsZCAqLwotCQkJCSAgIAorCiAJCQkJdTMyIHRpbWVfbm93LCB0aW1l
X2xhc3Q7CiAJCQkJdW5zaWduZWQgbG9uZyBmbGFndjsKIAkJCQl1bnNpZ25lZCBudW07CiAJCQkJ
c3RydWN0IGh3X2ZpYiAqKiBod19maWJfcG9vbCwgKiogaHdfZmliX3A7CiAJCQkJc3RydWN0IGZp
YiAqKiBmaWJfcG9vbCwgKiogZmliX3A7Ci0JCQkKKwogCQkJCS8qIFNuaWZmIGV2ZW50cyAqLwot
CQkJCWlmICgoYWlmY21kLT5jb21tYW5kID09IAorCQkJCWlmICgoYWlmY21kLT5jb21tYW5kID09
CiAJCQkJICAgICBjcHVfdG9fbGUzMihBaWZDbWRFdmVudE5vdGlmeSkpIHx8Ci0JCQkJICAgIChh
aWZjbWQtPmNvbW1hbmQgPT0gCisJCQkJICAgIChhaWZjbWQtPmNvbW1hbmQgPT0KIAkJCQkgICAg
IGNwdV90b19sZTMyKEFpZkNtZEpvYlByb2dyZXNzKSkpIHsKIAkJCQkJYWFjX2hhbmRsZV9haWYo
ZGV2LCBmaWIpOwogCQkJCX0KQEAgLTE1ODgsNyArMTU5Miw3IEBACiAJCQkJc3Bpbl9sb2NrX2ly
cXNhdmUoJmRldi0+ZmliX2xvY2ssIGZsYWd2KTsKIAkJCQllbnRyeSA9IGRldi0+ZmliX2xpc3Qu
bmV4dDsKIAkJCQkvKgotCQkJCSAqIEZvciBlYWNoIENvbnRleHQgdGhhdCBpcyBvbiB0aGUgCisJ
CQkJICogRm9yIGVhY2ggQ29udGV4dCB0aGF0IGlzIG9uIHRoZQogCQkJCSAqIGZpYmN0eExpc3Qs
IG1ha2UgYSBjb3B5IG9mIHRoZQogCQkJCSAqIGZpYiwgYW5kIHRoZW4gc2V0IHRoZSBldmVudCB0
byB3YWtlIHVwIHRoZQogCQkJCSAqIHRocmVhZCB0aGF0IGlzIHdhaXRpbmcgZm9yIGl0LgpAQCAt
MTYxMyw3ICsxNjE3LDcgQEAKIAkJCQkJCSAqLwogCQkJCQkJdGltZV9sYXN0ID0gZmliY3R4LT5q
aWZmaWVzOwogCQkJCQkJLyoKLQkJCQkJCSAqIEhhcyBpdCBiZWVuID4gMiBtaW51dGVzIAorCQkJ
CQkJICogSGFzIGl0IGJlZW4gPiAyIG1pbnV0ZXMKIAkJCQkJCSAqIHNpbmNlIHRoZSBsYXN0IHJl
YWQgb2ZmCiAJCQkJCQkgKiB0aGUgcXVldWU/CiAJCQkJCQkgKi8KQEAgLTE2NDQsNyArMTY0OCw3
IEBACiAJCQkJCQkgKi8KIAkJCQkJCWxpc3RfYWRkX3RhaWwoJm5ld2ZpYi0+ZmlibGluaywgJmZp
YmN0eC0+ZmliX2xpc3QpOwogCQkJCQkJZmliY3R4LT5jb3VudCsrOwotCQkJCQkJLyogCisJCQkJ
CQkvKgogCQkJCQkJICogU2V0IHRoZSBldmVudCB0byB3YWtlIHVwIHRoZQogCQkJCQkJICogdGhy
ZWFkIHRoYXQgaXMgd2FpdGluZy4KIAkJCQkJCSAqLwpkaWZmIC1ydSBhL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2xpbml0LmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCi0tLSBhL2RyaXZl
cnMvc2NzaS9hYWNyYWlkL2xpbml0LmMJMjAwOC0wMS0xNiAwOToyODowOC4yNDc4MzU4MDMgLTA1
MDAKKysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYwkyMDA4LTAxLTE2IDEwOjAxOjMx
Ljk5NTUyMDExNCAtMDUwMApAQCAtMTU5LDcgKzE1OSw3IEBACiBNT0RVTEVfREVWSUNFX1RBQkxF
KHBjaSwgYWFjX3BjaV90YmwpOwogCiAvKgotICogZG1iIC0gRm9yIG5vdyB3ZSBhZGQgdGhlIG51
bWJlciBvZiBjaGFubmVscyB0byB0aGlzIHN0cnVjdHVyZS4gIAorICogZG1iIC0gRm9yIG5vdyB3
ZSBhZGQgdGhlIG51bWJlciBvZiBjaGFubmVscyB0byB0aGlzIHN0cnVjdHVyZS4KICAqIEluIHRo
ZSBmdXR1cmUgd2Ugc2hvdWxkIGFkZCBhIGZpYiB0aGF0IHJlcG9ydHMgdGhlIG51bWJlciBvZiBj
aGFubmVscwogICogZm9yIHRoZSBjYXJkLiAgQXQgdGhhdCB0aW1lIHdlIGNhbiByZW1vdmUgdGhl
IGNoYW5uZWxzIGZyb20gaGVyZQogICovCkBAIC0yMzksNyArMjM5LDcgQEAKICAqCVF1ZXVlcyBh
IGNvbW1hbmQgZm9yIGV4ZWN1dGlvbiBieSB0aGUgYXNzb2NpYXRlZCBIb3N0IEFkYXB0ZXIuCiAg
KgogICoJVE9ETzogdW5pZnkgd2l0aCBhYWNfc2NzaV9jbWQoKS4KLSAqLyAKKyAqLwogCiBzdGF0
aWMgaW50IGFhY19xdWV1ZWNvbW1hbmQoc3RydWN0IHNjc2lfY21uZCAqY21kLCB2b2lkICgqZG9u
ZSkoc3RydWN0IHNjc2lfY21uZCAqKSkKIHsKQEAgLTI1OCw3ICsyNTgsNyBAQAogCX0KIAljbWQt
PlNDcC5waGFzZSA9IEFBQ19PV05FUl9MT1dMRVZFTDsKIAlyZXR1cm4gKGFhY19zY3NpX2NtZChj
bWQpID8gRkFJTEVEIDogMCk7Ci19IAorfQogCiAvKioKICAqCWFhY19pbmZvCQktCVJldHVybnMg
dGhlIGhvc3QgYWRhcHRlciBuYW1lCkBAIC0yOTIsMjEgKzI5MiwyMSBAQAogICoJQGNhcGFjaXR5
OiB0aGUgc2VjdG9yIGNhcGFjaXR5IG9mIHRoZSBkaXNrCiAgKglAZ2VvbTogZ2VvbWV0cnkgYmxv
Y2sgdG8gZmlsbCBpbgogICoKLSAqCVJldHVybiB0aGUgSGVhZHMvU2VjdG9ycy9DeWxpbmRlcnMg
QklPUyBEaXNrIFBhcmFtZXRlcnMgZm9yIERpc2suICAKLSAqCVRoZSBkZWZhdWx0IGRpc2sgZ2Vv
bWV0cnkgaXMgNjQgaGVhZHMsIDMyIHNlY3RvcnMsIGFuZCB0aGUgYXBwcm9wcmlhdGUgCi0gKglu
dW1iZXIgb2YgY3lsaW5kZXJzIHNvIGFzIG5vdCB0byBleGNlZWQgZHJpdmUgY2FwYWNpdHkuICBJ
biBvcmRlciBmb3IgCisgKglSZXR1cm4gdGhlIEhlYWRzL1NlY3RvcnMvQ3lsaW5kZXJzIEJJT1Mg
RGlzayBQYXJhbWV0ZXJzIGZvciBEaXNrLgorICoJVGhlIGRlZmF1bHQgZGlzayBnZW9tZXRyeSBp
cyA2NCBoZWFkcywgMzIgc2VjdG9ycywgYW5kIHRoZSBhcHByb3ByaWF0ZQorICoJbnVtYmVyIG9m
IGN5bGluZGVycyBzbyBhcyBub3QgdG8gZXhjZWVkIGRyaXZlIGNhcGFjaXR5LiAgSW4gb3JkZXIg
Zm9yCiAgKglkaXNrcyBlcXVhbCB0byBvciBsYXJnZXIgdGhhbiAxIEdCIHRvIGJlIGFkZHJlc3Nh
YmxlIGJ5IHRoZSBCSU9TCi0gKgl3aXRob3V0IGV4Y2VlZGluZyB0aGUgQklPUyBsaW1pdGF0aW9u
IG9mIDEwMjQgY3lsaW5kZXJzLCBFeHRlbmRlZCAKLSAqCVRyYW5zbGF0aW9uIHNob3VsZCBiZSBl
bmFibGVkLiAgIFdpdGggRXh0ZW5kZWQgVHJhbnNsYXRpb24gZW5hYmxlZCwgCi0gKglkcml2ZXMg
YmV0d2VlbiAxIEdCIGluY2x1c2l2ZSBhbmQgMiBHQiBleGNsdXNpdmUgYXJlIGdpdmVuIGEgZGlz
ayAKLSAqCWdlb21ldHJ5IG9mIDEyOCBoZWFkcyBhbmQgMzIgc2VjdG9ycywgYW5kIGRyaXZlcyBh
Ym92ZSAyIEdCIGluY2x1c2l2ZSAKLSAqCWFyZSBnaXZlbiBhIGRpc2sgZ2VvbWV0cnkgb2YgMjU1
IGhlYWRzIGFuZCA2MyBzZWN0b3JzLiAgSG93ZXZlciwgaWYgCi0gKgl0aGUgQklPUyBkZXRlY3Rz
IHRoYXQgdGhlIEV4dGVuZGVkIFRyYW5zbGF0aW9uIHNldHRpbmcgZG9lcyBub3QgbWF0Y2ggCi0g
Kgl0aGUgZ2VvbWV0cnkgaW4gdGhlIHBhcnRpdGlvbiB0YWJsZSwgdGhlbiB0aGUgdHJhbnNsYXRp
b24gaW5mZXJyZWQgCi0gKglmcm9tIHRoZSBwYXJ0aXRpb24gdGFibGUgd2lsbCBiZSB1c2VkIGJ5
IHRoZSBCSU9TLCBhbmQgYSB3YXJuaW5nIG1heSAKKyAqCXdpdGhvdXQgZXhjZWVkaW5nIHRoZSBC
SU9TIGxpbWl0YXRpb24gb2YgMTAyNCBjeWxpbmRlcnMsIEV4dGVuZGVkCisgKglUcmFuc2xhdGlv
biBzaG91bGQgYmUgZW5hYmxlZC4gICBXaXRoIEV4dGVuZGVkIFRyYW5zbGF0aW9uIGVuYWJsZWQs
CisgKglkcml2ZXMgYmV0d2VlbiAxIEdCIGluY2x1c2l2ZSBhbmQgMiBHQiBleGNsdXNpdmUgYXJl
IGdpdmVuIGEgZGlzaworICoJZ2VvbWV0cnkgb2YgMTI4IGhlYWRzIGFuZCAzMiBzZWN0b3JzLCBh
bmQgZHJpdmVzIGFib3ZlIDIgR0IgaW5jbHVzaXZlCisgKglhcmUgZ2l2ZW4gYSBkaXNrIGdlb21l
dHJ5IG9mIDI1NSBoZWFkcyBhbmQgNjMgc2VjdG9ycy4gIEhvd2V2ZXIsIGlmCisgKgl0aGUgQklP
UyBkZXRlY3RzIHRoYXQgdGhlIEV4dGVuZGVkIFRyYW5zbGF0aW9uIHNldHRpbmcgZG9lcyBub3Qg
bWF0Y2gKKyAqCXRoZSBnZW9tZXRyeSBpbiB0aGUgcGFydGl0aW9uIHRhYmxlLCB0aGVuIHRoZSB0
cmFuc2xhdGlvbiBpbmZlcnJlZAorICoJZnJvbSB0aGUgcGFydGl0aW9uIHRhYmxlIHdpbGwgYmUg
dXNlZCBieSB0aGUgQklPUywgYW5kIGEgd2FybmluZyBtYXkKICAqCWJlIGRpc3BsYXllZC4KICAq
LwotIAorCiBzdGF0aWMgaW50IGFhY19iaW9zcGFybShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYs
IHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCiAJCQlzZWN0b3JfdCBjYXBhY2l0eSwgaW50ICpn
ZW9tKQogewpAQCAtMzMzLDEwICszMzMsMTAgQEAKIAogCXBhcmFtLT5jeWxpbmRlcnMgPSBjYXBf
dG9fY3lscyhjYXBhY2l0eSwgcGFyYW0tPmhlYWRzICogcGFyYW0tPnNlY3RvcnMpOwogCi0JLyog
CisJLyoKIAkgKglSZWFkIHRoZSBmaXJzdCAxMDI0IGJ5dGVzIGZyb20gdGhlIGRpc2sgZGV2aWNl
LCBpZiB0aGUgYm9vdAogCSAqCXNlY3RvciBwYXJ0aXRpb24gdGFibGUgaXMgdmFsaWQsIHNlYXJj
aCBmb3IgYSBwYXJ0aXRpb24gdGFibGUKLQkgKgllbnRyeSB3aG9zZSBlbmRfaGVhZCBtYXRjaGVz
IG9uZSBvZiB0aGUgc3RhbmRhcmQgZ2VvbWV0cnkgCisJICoJZW50cnkgd2hvc2UgZW5kX2hlYWQg
bWF0Y2hlcyBvbmUgb2YgdGhlIHN0YW5kYXJkIGdlb21ldHJ5CiAJICoJdHJhbnNsYXRpb25zICgg
NjQvMzIsIDEyOC8zMiwgMjU1LzYzICkuCiAJICovCiAJYnVmID0gc2NzaV9iaW9zX3B0YWJsZShi
ZGV2KTsKQEAgLTU5Niw3ICs1OTYsNyBAQAogCQkJY21kLT5TQ3AucGhhc2UgPSBBQUNfT1dORVJf
RVJST1JfSEFORExFUjsKIAkJfQogCX0KLQlwcmludGsoS0VSTl9FUlIgIiVzOiBIb3N0IGFkYXB0
ZXIgcmVzZXQgcmVxdWVzdC4gU0NTSSBoYW5nID9cbiIsIAorCXByaW50ayhLRVJOX0VSUiAiJXM6
IEhvc3QgYWRhcHRlciByZXNldCByZXF1ZXN0LiBTQ1NJIGhhbmcgP1xuIiwKIAkJCQkJQUFDX0RS
SVZFUk5BTUUpOwogCiAJaWYgKChjb3VudCA9IGFhY19jaGVja19oZWFsdGgoYWFjKSkpCkBAIC02
ODcsOCArNjg3LDggQEAKICAqCUJ1Z3M6IE5lZWRzIGxvY2tpbmcgYWdhaW5zdCBwYXJhbGxlbCBp
b2N0bHMgbG93ZXIgZG93bgogICoJQnVnczogTmVlZHMgdG8gaGFuZGxlIGhvdCBwbHVnZ2luZwog
ICovCi0gCi1zdGF0aWMgaW50IGFhY19jZmdfaW9jdGwoc3RydWN0IGlub2RlICppbm9kZSwgIHN0
cnVjdCBmaWxlICpmaWxlLAorCitzdGF0aWMgaW50IGFhY19jZmdfaW9jdGwoc3RydWN0IGlub2Rl
ICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUsCiAJCXVuc2lnbmVkIGludCBjbWQsIHVuc2lnbmVk
IGxvbmcgYXJnKQogewogCWlmICghY2FwYWJsZShDQVBfU1lTX1JBV0lPKSkKQEAgLTcwMSw3ICs3
MDEsNyBAQAogewogCWxvbmcgcmV0OwogCWxvY2tfa2VybmVsKCk7Ci0Jc3dpdGNoIChjbWQpIHsg
CisJc3dpdGNoIChjbWQpIHsKIAljYXNlIEZTQUNUTF9NSU5JUE9SVF9SRVZfQ0hFQ0s6CiAJY2Fz
ZSBGU0FDVExfU0VOREZJQjoKIAljYXNlIEZTQUNUTF9PUEVOX0dFVF9BREFQVEVSX0ZJQjoKQEAg
LTcxMSwxNCArNzExLDE0IEBACiAJY2FzZSBGU0FDVExfUVVFUllfRElTSzoKIAljYXNlIEZTQUNU
TF9ERUxFVEVfRElTSzoKIAljYXNlIEZTQUNUTF9GT1JDRV9ERUxFVEVfRElTSzoKLQljYXNlIEZT
QUNUTF9HRVRfQ09OVEFJTkVSUzogCisJY2FzZSBGU0FDVExfR0VUX0NPTlRBSU5FUlM6CiAJY2Fz
ZSBGU0FDVExfU0VORF9MQVJHRV9GSUI6CiAJCXJldCA9IGFhY19kb19pb2N0bChkZXYsIGNtZCwg
KHZvaWQgX191c2VyICopYXJnKTsKIAkJYnJlYWs7CiAKIAljYXNlIEZTQUNUTF9HRVRfTkVYVF9B
REFQVEVSX0ZJQjogewogCQlzdHJ1Y3QgZmliX2lvY3RsIF9fdXNlciAqZjsKLQkJCisKIAkJZiA9
IGNvbXBhdF9hbGxvY191c2VyX3NwYWNlKHNpemVvZigqZikpOwogCQlyZXQgPSAwOwogCQlpZiAo
Y2xlYXJfdXNlcihmLCBzaXplb2YoKmYpKSkKQEAgLTczMSw5ICs3MzEsOSBAQAogCX0KIAogCWRl
ZmF1bHQ6Ci0JCXJldCA9IC1FTk9JT0NUTENNRDsgCisJCXJldCA9IC1FTk9JT0NUTENNRDsKIAkJ
YnJlYWs7Ci0JfSAKKwl9CiAJdW5sb2NrX2tlcm5lbCgpOwogCXJldHVybiByZXQ7CiB9CkBAIC03
OTcsNyArNzk3LDcgQEAKIAlpbnQgbGVuLCB0bXA7CiAKIAl0bXAgPSBsZTMyX3RvX2NwdShkZXYt
PmFkYXB0ZXJfaW5mby5rZXJuZWxyZXYpOwotCWxlbiA9IHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpF
LCAiJWQuJWQtJWRbJWRdXG4iLCAKKwlsZW4gPSBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgIiVk
LiVkLSVkWyVkXVxuIiwKIAkgIHRtcCA+PiAyNCwgKHRtcCA+PiAxNikgJiAweGZmLCB0bXAgJiAw
eGZmLAogCSAgbGUzMl90b19jcHUoZGV2LT5hZGFwdGVyX2luZm8ua2VybmVsYnVpbGQpKTsKIAly
ZXR1cm4gbGVuOwpAQCAtODEwLDcgKzgxMCw3IEBACiAJaW50IGxlbiwgdG1wOwogCiAJdG1wID0g
bGUzMl90b19jcHUoZGV2LT5hZGFwdGVyX2luZm8ubW9uaXRvcnJldik7Ci0JbGVuID0gc25wcmlu
dGYoYnVmLCBQQUdFX1NJWkUsICIlZC4lZC0lZFslZF1cbiIsIAorCWxlbiA9IHNucHJpbnRmKGJ1
ZiwgUEFHRV9TSVpFLCAiJWQuJWQtJWRbJWRdXG4iLAogCSAgdG1wID4+IDI0LCAodG1wID4+IDE2
KSAmIDB4ZmYsIHRtcCAmIDB4ZmYsCiAJICBsZTMyX3RvX2NwdShkZXYtPmFkYXB0ZXJfaW5mby5t
b25pdG9yYnVpbGQpKTsKIAlyZXR1cm4gbGVuOwpAQCAtODIzLDcgKzgyMyw3IEBACiAJaW50IGxl
biwgdG1wOwogCiAJdG1wID0gbGUzMl90b19jcHUoZGV2LT5hZGFwdGVyX2luZm8uYmlvc3Jldik7
Ci0JbGVuID0gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlZC4lZC0lZFslZF1cbiIsIAorCWxl
biA9IHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiJWQuJWQtJWRbJWRdXG4iLAogCSAgdG1wID4+
IDI0LCAodG1wID4+IDE2KSAmIDB4ZmYsIHRtcCAmIDB4ZmYsCiAJICBsZTMyX3RvX2NwdShkZXYt
PmFkYXB0ZXJfaW5mby5iaW9zYnVpbGQpKTsKIAlyZXR1cm4gbGVuOwpAQCAtOTgzLDIyICs5ODMs
MjIgQEAKIAkuY29tcGF0X2lvY3RsCQkJPSBhYWNfY29tcGF0X2lvY3RsLAogI2VuZGlmCiAJLnF1
ZXVlY29tbWFuZCAgIAkJPSBhYWNfcXVldWVjb21tYW5kLAotCS5iaW9zX3BhcmFtICAgICAJCT0g
YWFjX2Jpb3NwYXJtLAkKKwkuYmlvc19wYXJhbSAgICAgCQk9IGFhY19iaW9zcGFybSwKIAkuc2hv
c3RfYXR0cnMJCQk9IGFhY19hdHRycywKIAkuc2xhdmVfY29uZmlndXJlCQk9IGFhY19zbGF2ZV9j
b25maWd1cmUsCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aAkJPSBhYWNfY2hhbmdlX3F1ZXVlX2RlcHRo
LAogCS5zZGV2X2F0dHJzCQkJPSBhYWNfZGV2X2F0dHJzLAogCS5laF9hYm9ydF9oYW5kbGVyCQk9
IGFhY19laF9hYm9ydCwKIAkuZWhfaG9zdF9yZXNldF9oYW5kbGVyCQk9IGFhY19laF9yZXNldCwK
LQkuY2FuX3F1ZXVlICAgICAgCQk9IEFBQ19OVU1fSU9fRklCLAkKKwkuY2FuX3F1ZXVlICAgICAg
CQk9IEFBQ19OVU1fSU9fRklCLAogCS50aGlzX2lkICAgICAgICAJCT0gTUFYSU1VTV9OVU1fQ09O
VEFJTkVSUywKIAkuc2dfdGFibGVzaXplICAgCQk9IDE2LAogCS5tYXhfc2VjdG9ycyAgICAJCT0g
MTI4LAogI2lmIChBQUNfTlVNX0lPX0ZJQiA+IDI1NikKIAkuY21kX3Blcl9sdW4JCQk9IDI1NiwK
LSNlbHNlCQkKLQkuY21kX3Blcl9sdW4gICAgCQk9IEFBQ19OVU1fSU9fRklCLCAKLSNlbmRpZgkK
KyNlbHNlCisJLmNtZF9wZXJfbHVuICAgIAkJPSBBQUNfTlVNX0lPX0ZJQiwKKyNlbmRpZgogCS51
c2VfY2x1c3RlcmluZwkJCT0gRU5BQkxFX0NMVVNURVJJTkcsCiAJLnVzZV9zZ19jaGFpbmluZwkJ
PSBFTkFCTEVfU0dfQ0hBSU5JTkcsCiAJLmVtdWxhdGVkICAgICAgICAgICAgICAgICAgICAgICA9
IDEsCkBAIC0xMDM1LDE4ICsxMDM1LDE4IEBACiAJCWdvdG8gb3V0OwogCWVycm9yID0gLUVOT0RF
VjsKIAotCWlmIChwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV8zMkJJVF9NQVNLKSB8fCAKKwlp
ZiAocGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfMzJCSVRfTUFTSykgfHwKIAkJCXBjaV9zZXRf
Y29uc2lzdGVudF9kbWFfbWFzayhwZGV2LCBETUFfMzJCSVRfTUFTSykpCiAJCWdvdG8gb3V0X2Rp
c2FibGVfcGRldjsKIAkvKgogCSAqIElmIHRoZSBxdWlyazMxIGJpdCBpcyBzZXQsIHRoZSBhZGFw
dGVyIG5lZWRzIGFkYXB0ZXIKIAkgKiB0byBkcml2ZXIgY29tbXVuaWNhdGlvbiBtZW1vcnkgdG8g
YmUgYWxsb2NhdGVkIGJlbG93IDJnaWcKIAkgKi8KLQlpZiAoYWFjX2RyaXZlcnNbaW5kZXhdLnF1
aXJrcyAmIEFBQ19RVUlSS18zMUJJVCkgCisJaWYgKGFhY19kcml2ZXJzW2luZGV4XS5xdWlya3Mg
JiBBQUNfUVVJUktfMzFCSVQpCiAJCWlmIChwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV8zMUJJ
VF9NQVNLKSB8fAogCQkJCXBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhwZGV2LCBETUFfMzFC
SVRfTUFTSykpCiAJCQlnb3RvIG91dF9kaXNhYmxlX3BkZXY7Ci0JCisKIAlwY2lfc2V0X21hc3Rl
cihwZGV2KTsKIAogCXNob3N0ID0gc2NzaV9ob3N0X2FsbG9jKCZhYWNfZHJpdmVyX3RlbXBsYXRl
LCBzaXplb2Yoc3RydWN0IGFhY19kZXYpKTsKQEAgLTEwNTksNyArMTA1OSw3IEBACiAJc2hvc3Qt
Pm1heF9jbWRfbGVuID0gMTY7CiAKIAlhYWMgPSAoc3RydWN0IGFhY19kZXYgKilzaG9zdC0+aG9z
dGRhdGE7Ci0JYWFjLT5zY3NpX2hvc3RfcHRyID0gc2hvc3Q7CQorCWFhYy0+c2NzaV9ob3N0X3B0
ciA9IHNob3N0OwogCWFhYy0+cGRldiA9IHBkZXY7CiAJYWFjLT5uYW1lID0gYWFjX2RyaXZlcl90
ZW1wbGF0ZS5uYW1lOwogCWFhYy0+aWQgPSBzaG9zdC0+dW5pcXVlX2lkOwpAQCAtMTA5Niw3ICsx
MDk2LDcgQEAKIAlpZiAoYWFjX2RyaXZlcnNbaW5kZXhdLnF1aXJrcyAmIEFBQ19RVUlSS18zMUJJ
VCkKIAkJaWYgKHBjaV9zZXRfZG1hX21hc2socGRldiwgRE1BXzMyQklUX01BU0spKQogCQkJZ290
byBvdXRfZGVpbml0OwotIAorCiAJYWFjLT5tYXhpbXVtX251bV9jaGFubmVscyA9IGFhY19kcml2
ZXJzW2luZGV4XS5jaGFubmVsczsKIAllcnJvciA9IGFhY19nZXRfYWRhcHRlcl9pbmZvKGFhYyk7
CiAJaWYgKGVycm9yIDwgMCkKQEAgLTExMDUsNyArMTEwNSw3IEBACiAJLyoKICAJICogTGV0cyBv
dmVycmlkZSBuZWdvdGlhdGlvbnMgYW5kIGRyb3AgdGhlIG1heGltdW0gU0cgbGltaXQgdG8gMzQK
ICAJICovCi0gCWlmICgoYWFjX2RyaXZlcnNbaW5kZXhdLnF1aXJrcyAmIEFBQ19RVUlSS18zNFNH
KSAmJiAKKyAJaWYgKChhYWNfZHJpdmVyc1tpbmRleF0ucXVpcmtzICYgQUFDX1FVSVJLXzM0U0cp
ICYmCiAJCQkoYWFjLT5zY3NpX2hvc3RfcHRyLT5zZ190YWJsZXNpemUgPiAzNCkpIHsKICAJCWFh
Yy0+c2NzaV9ob3N0X3B0ci0+c2dfdGFibGVzaXplID0gMzQ7CiAgCQlhYWMtPnNjc2lfaG9zdF9w
dHItPm1heF9zZWN0b3JzCkBAIC0xMTIyLDExICsxMTIyLDExIEBACiAJLyoKIAkgKiBGaXJ3YXJl
IHByaW50ZiB3b3JrcyBvbmx5IHdpdGggb2xkZXIgZmlybXdhcmUuCiAJICovCi0JaWYgKGFhY19k
cml2ZXJzW2luZGV4XS5xdWlya3MgJiBBQUNfUVVJUktfMzRTRykgCisJaWYgKGFhY19kcml2ZXJz
W2luZGV4XS5xdWlya3MgJiBBQUNfUVVJUktfMzRTRykKIAkJYWFjLT5wcmludGZfZW5hYmxlZCA9
IDE7CiAJZWxzZQogCQlhYWMtPnByaW50Zl9lbmFibGVkID0gMDsKLSAKKwogIAkvKgogCSAqIG1h
eCBjaGFubmVsIHdpbGwgYmUgdGhlIHBoeXNpY2FsIGNoYW5uZWxzIHBsdXMgMSB2aXJ0dWFsIGNo
YW5uZWwKIAkgKiBhbGwgY29udGFpbmVycyBhcmUgb24gdGhlIHZpcnR1YWwgY2hhbm5lbCAwIChD
T05UQUlORVJfQ0hBTk5FTCkKQEAgLTEyMDQsMTAgKzEyMDQsMTAgQEAKIAlrZnJlZShhYWMtPnF1
ZXVlcyk7CiAKIAlhYWNfYWRhcHRlcl9pb3JlbWFwKGFhYywgMCk7Ci0JCisKIAlrZnJlZShhYWMt
PmZpYnMpOwogCWtmcmVlKGFhYy0+ZnNhX2Rldik7Ci0JCisKIAlsaXN0X2RlbCgmYWFjLT5lbnRy
eSk7CiAJc2NzaV9ob3N0X3B1dChzaG9zdCk7CiAJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOwpA
QCAtMTIyOCw3ICsxMjI4LDcgQEAKIHN0YXRpYyBpbnQgX19pbml0IGFhY19pbml0KHZvaWQpCiB7
CiAJaW50IGVycm9yOwotCQorCiAJcHJpbnRrKEtFUk5fSU5GTyAiQWRhcHRlYyAlcyBkcml2ZXIg
JXNcbiIsCiAJICBBQUNfRFJJVkVSTkFNRSwgYWFjX2RyaXZlcl92ZXJzaW9uKTsKIAo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439065895ADPE2K703adapte_--
