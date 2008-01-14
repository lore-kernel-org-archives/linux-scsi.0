From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: replace '<?:' with min_t()
Date: Mon, 14 Jan 2008 07:25:33 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA974@ADPE2K703.adaptec.com>
References: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
 <a789287f8ac2eef0d95c6cbb08f68c122b5f7ec4.tomof@acm.org>
 <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA880@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEA974ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:54640 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYANPZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 10:25:37 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA880@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'fujita.tomonori@lab.ntt.co.jp'" <fujita.tomonori@lab.ntt.co.jp>, 'FUJITA Tomonori' <tomof@acm.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEA974ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The promised min_t() cleanup. Purely cosmetic.

This attached patch is against current scsi-misc-2.6 *after* http://marc.in=
fo/?l=3Dlinux-scsi&m=3D120020681219191&w=3D2 is applied. James, sorry if th=
is patch is being submitted too early in the pipeline ...

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |   40 ++++++++++++++++---------------------=
---
 1 file changed, 16 insertions(+), 24 deletions(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Monday, January 14, 2008 8:24 AM
> To: 'FUJITA Tomonori'; 'James.Bottomley@HansenPartnership.com'
> Cc: 'linux-scsi@vger.kernel.org'; 'fujita.tomonori@lab.ntt.co.jp'
> Subject: RE: [PATCH 2/2] replace sizeof sense_buffer with
> SCSI_SENSE_BUFFERSIZE
>
> ACK on ips, aacraid and dpt_i2o bits. Cursory inspection of
> other bits as well. Thanks Fujita, looks good!
>
> Will do a 'min()' cleanup on aacraid once patch propagates
> into scsi-misc-2.6
>
> Sincerely -- Mark Salyzyn
>
> cur*so*ry - adjective
>         going rapidly over something, without noticing
> details; hasty; superficial. spedd reeding
>
> . . .
> > o This is a 'grep and replace' style patch but cleans up
> dpt_i2o a bit
> > as by permission of Mark (I use min macro).
> >
> > o The previous version overlooked some sizeof sense_buffer lines in
> > aacraid and qla4xxx.
> . . .
> > diff --git a/drivers/scsi/aacraid/aachba.c
> > b/drivers/scsi/aacraid/aachba.c
> > index 62d9516..aadedbd 100644
> > --- a/drivers/scsi/aacraid/aachba.c
> > +++ b/drivers/scsi/aacraid/aachba.c
> > @@ -912,8 +912,8 @@ static int aac_bounds_32(struct aac_dev *
> > dev, struct scsi_cmnd * cmd, u64 lba)
> >                             ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
> >                             0, 0);
> >                 memcpy(cmd->sense_buffer,
> > &dev->fsa_dev[cid].sense_data,
> > -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > sizeof(cmd->sense_buffer))
> > -                   ? sizeof(cmd->sense_buffer)
> > +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > SCSI_SENSE_BUFFERSIZE)
> > +                   ? SCSI_SENSE_BUFFERSIZE
> >                     : sizeof(dev->fsa_dev[cid].sense_data));
> >                 cmd->scsi_done(cmd);
> >                 return 1;
> > @@ -1525,8 +1525,8 @@ static void io_callback(void *context,
> > struct fib * fibptr)
> >
> > ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
> >                                     0, 0);
> >                 memcpy(scsicmd->sense_buffer,
> > &dev->fsa_dev[cid].sense_data,
> > -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > sizeof(scsicmd->sense_buffer))
> > -                   ? sizeof(scsicmd->sense_buffer)
> > +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > SCSI_SENSE_BUFFERSIZE)
> > +                   ? SCSI_SENSE_BUFFERSIZE
> >                     : sizeof(dev->fsa_dev[cid].sense_data));
> >         }
> >         aac_fib_complete(fibptr);
> > @@ -1739,8 +1739,8 @@ static void synchronize_callback(void
> > *context, struct fib *fibptr)
> >
> > ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
> >                                     0, 0);
> >                 memcpy(cmd->sense_buffer,
> > &dev->fsa_dev[cid].sense_data,
> > -                 min(sizeof(dev->fsa_dev[cid].sense_data),
> > -                         sizeof(cmd->sense_buffer)));
> > +                      min_t(size_t,
> > sizeof(dev->fsa_dev[cid].sense_data),
> > +                            SCSI_SENSE_BUFFERSIZE));
> >         }
> >
> >         aac_fib_complete(fibptr);
> > @@ -1949,8 +1949,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
> >                             SENCODE_INVALID_COMMAND,
> >                             ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
> >                 memcpy(scsicmd->sense_buffer,
> > &dev->fsa_dev[cid].sense_data,
> > -                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > sizeof(scsicmd->sense_buffer))
> > -                   ? sizeof(scsicmd->sense_buffer)
> > +                 (sizeof(dev->fsa_dev[cid].sense_data) >
> > SCSI_SENSE_BUFFERSIZE)
> > +                   ? SCSI_SENSE_BUFFERSIZE
> >                     : sizeof(dev->fsa_dev[cid].sense_data));
> >                 scsicmd->scsi_done(scsicmd);
> >                 return 0;
> > @@ -2002,8 +2002,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
> >                                 memcpy(scsicmd->sense_buffer,
> >                                   &dev->fsa_dev[cid].sense_data,
> >
> > (sizeof(dev->fsa_dev[cid].sense_data) >
> > -                                   sizeof(scsicmd->sense_buffer))
> > -                                      ?
> sizeof(scsicmd->sense_buffer)
> > +                                   SCSI_SENSE_BUFFERSIZE)
> > +                                      ? SCSI_SENSE_BUFFERSIZE
> >                                        :
> > sizeof(dev->fsa_dev[cid].sense_data));
> >                         }
> >                         scsicmd->scsi_done(scsicmd);
> > @@ -2259,8 +2259,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
> >                                 ILLEGAL_REQUEST,
> > SENCODE_INVALID_COMMAND,
> >                                 ASENCODE_INVALID_COMMAND,
> 0, 0, 0, 0);
> >                         memcpy(scsicmd->sense_buffer,
> > &dev->fsa_dev[cid].sense_data,
> > -
> > (sizeof(dev->fsa_dev[cid].sense_data) >
> sizeof(scsicmd->sense_buffer))
> > -                           ? sizeof(scsicmd->sense_buffer)
> > +
> > (sizeof(dev->fsa_dev[cid].sense_data) > SCSI_SENSE_BUFFERSIZE)
> > +                           ? SCSI_SENSE_BUFFERSIZE
> >                             : sizeof(dev->fsa_dev[cid].sense_data));
> >                         scsicmd->scsi_done(scsicmd);
> >                         return 0;
> > @@ -2422,8 +2422,8 @@ static void aac_srb_callback(void
> > *context, struct fib * fibptr)
> >                 int len;
> >                 printk(KERN_WARNING "aac_srb_callback: srb
> > failed, status =3D %d\n", le32_to_cpu(srbreply->status));
> >                 len =3D (le32_to_cpu(srbreply->sense_data_size) >
> > -                               sizeof(scsicmd->sense_buffer)) ?
> > -                               sizeof(scsicmd->sense_buffer) :
> > +                               SCSI_SENSE_BUFFERSIZE) ?
> > +                               SCSI_SENSE_BUFFERSIZE :
> >
> > le32_to_cpu(srbreply->sense_data_size);
> >                 scsicmd->result =3D DID_ERROR << 16 |
> > COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
> >                 memcpy(scsicmd->sense_buffer,
> > srbreply->sense_data, len);
> > @@ -2528,8 +2528,8 @@ static void aac_srb_callback(void
> > *context, struct fib * fibptr)
> >                 int len;
> >                 scsicmd->result |=3D SAM_STAT_CHECK_CONDITION;
> >                 len =3D (le32_to_cpu(srbreply->sense_data_size) >
> > -                               sizeof(scsicmd->sense_buffer)) ?
> > -                               sizeof(scsicmd->sense_buffer) :
> > +                               SCSI_SENSE_BUFFERSIZE) ?
> > +                               SCSI_SENSE_BUFFERSIZE :
> >
> > le32_to_cpu(srbreply->sense_data_size);
> >  #ifdef AAC_DETAILED_STATUS_INFO
> >                 printk(KERN_WARNING "aac_srb_callback: check
> > condition, status =3D %d len=3D%d\n",

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEA974ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_min.patch"
Content-Description: aacraid_min.patch
Content-Disposition: attachment; filename="aacraid_min.patch"; size=3685;
	creation-date="Mon, 14 Jan 2008 06:58:19 GMT";
	modification-date="Mon, 14 Jan 2008 06:58:19 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMTQgMDk6NTU6NTIuOTQ0MDU1OTU1IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMTQgMDk6NTc6MzkuNTEyNjMxNjcwIC0wNTAwCkBAIC05MTIsOSAr
OTEyLDggQEAKIAkJCSAgICBBU0VOQ09ERV9JTlRFUk5BTF9UQVJHRVRfRkFJTFVSRSwgMCwgMCwK
IAkJCSAgICAwLCAwKTsKIAkJbWVtY3B5KGNtZC0+c2Vuc2VfYnVmZmVyLCAmZGV2LT5mc2FfZGV2
W2NpZF0uc2Vuc2VfZGF0YSwKLQkJICAoc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2Rh
dGEpID4gU0NTSV9TRU5TRV9CVUZGRVJTSVpFKQotCQkgICAgPyBTQ1NJX1NFTlNFX0JVRkZFUlNJ
WkUKLQkJICAgIDogc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpKTsKKwkJICAg
ICAgIG1pbl90KHNpemVfdCwgc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpLAor
CQkgICAgICAgICAgICAgU0NTSV9TRU5TRV9CVUZGRVJTSVpFKSk7CiAJCWNtZC0+c2NzaV9kb25l
KGNtZCk7CiAJCXJldHVybiAxOwogCX0KQEAgLTE1MjUsOSArMTUyNCw4IEBACiAJCQkJICAgIEFT
RU5DT0RFX0lOVEVSTkFMX1RBUkdFVF9GQUlMVVJFLCAwLCAwLAogCQkJCSAgICAwLCAwKTsKIAkJ
bWVtY3B5KHNjc2ljbWQtPnNlbnNlX2J1ZmZlciwgJmRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2Rh
dGEsCi0JCSAgKHNpemVvZihkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRhKSA+IFNDU0lfU0VO
U0VfQlVGRkVSU0laRSkKLQkJICAgID8gU0NTSV9TRU5TRV9CVUZGRVJTSVpFCi0JCSAgICA6IHNp
emVvZihkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRhKSk7CisJCSAgICAgICBtaW5fdChzaXpl
X3QsIHNpemVvZihkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRhKSwKKwkJICAgICAgICAgICAg
IFNDU0lfU0VOU0VfQlVGRkVSU0laRSkpOwogCX0KIAlhYWNfZmliX2NvbXBsZXRlKGZpYnB0cik7
CiAJYWFjX2ZpYl9mcmVlKGZpYnB0cik7CkBAIC0xOTQ5LDkgKzE5NDcsOCBAQAogCQkJICAgIFNF
TkNPREVfSU5WQUxJRF9DT01NQU5ELAogCQkJICAgIEFTRU5DT0RFX0lOVkFMSURfQ09NTUFORCwg
MCwgMCwgMCwgMCk7CiAJCW1lbWNweShzY3NpY21kLT5zZW5zZV9idWZmZXIsICZkZXYtPmZzYV9k
ZXZbY2lkXS5zZW5zZV9kYXRhLAotCQkgIChzaXplb2YoZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2Vf
ZGF0YSkgPiBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpCi0JCSAgICA/IFNDU0lfU0VOU0VfQlVGRkVS
U0laRQotCQkgICAgOiBzaXplb2YoZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2VfZGF0YSkpOworCQkg
ICAgICAgbWluX3Qoc2l6ZV90LCBzaXplb2YoZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2VfZGF0YSks
CisJCSAgICAgICAgICAgICBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpKTsKIAkJc2NzaWNtZC0+c2Nz
aV9kb25lKHNjc2ljbWQpOwogCQlyZXR1cm4gMDsKIAl9CkBAIC0yMDAxLDEwICsxOTk4LDkgQEAK
IAkJCQkgIEFTRU5DT0RFX05PX1NFTlNFLCAwLCA3LCAyLCAwKTsKIAkJCQltZW1jcHkoc2NzaWNt
ZC0+c2Vuc2VfYnVmZmVyLAogCQkJCSAgJmRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEsCi0J
CQkJICAoc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpID4KLQkJCQkgICAgU0NT
SV9TRU5TRV9CVUZGRVJTSVpFKQotCQkJCSAgICAgICA/IFNDU0lfU0VOU0VfQlVGRkVSU0laRQot
CQkJCSAgICAgICA6IHNpemVvZihkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRhKSk7CisJCSAg
CQkgIG1pbl90KHNpemVfdCwKKwkJCQkgICAgICAgIHNpemVvZihkZXYtPmZzYV9kZXZbY2lkXS5z
ZW5zZV9kYXRhKSwKKwkJCQkgICAgICAgIFNDU0lfU0VOU0VfQlVGRkVSU0laRSkpOwogCQkJfQog
CQkJc2NzaWNtZC0+c2NzaV9kb25lKHNjc2ljbWQpOwogCQkJcmV0dXJuIDA7CkBAIC0yMjU5LDkg
KzIyNTUsOSBAQAogCQkJCUlMTEVHQUxfUkVRVUVTVCwgU0VOQ09ERV9JTlZBTElEX0NPTU1BTkQs
CiAJCQkJQVNFTkNPREVfSU5WQUxJRF9DT01NQU5ELCAwLCAwLCAwLCAwKTsKIAkJCW1lbWNweShz
Y3NpY21kLT5zZW5zZV9idWZmZXIsICZkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRhLAotCQkJ
ICAoc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpID4gU0NTSV9TRU5TRV9CVUZG
RVJTSVpFKQotCQkJICAgID8gU0NTSV9TRU5TRV9CVUZGRVJTSVpFCi0JCQkgICAgOiBzaXplb2Yo
ZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2VfZGF0YSkpOworCQkJCW1pbl90KHNpemVfdCwKKwkJCQkg
ICAgICBzaXplb2YoZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2VfZGF0YSksCisJCQkJICAgICAgU0NT
SV9TRU5TRV9CVUZGRVJTSVpFKSk7CiAJCQlzY3NpY21kLT5zY3NpX2RvbmUoc2NzaWNtZCk7CiAJ
CQlyZXR1cm4gMDsKIAl9CkBAIC0yNDIxLDEwICsyNDE3LDggQEAKIAlpZiAobGUzMl90b19jcHUo
c3JicmVwbHktPnN0YXR1cykgIT0gU1RfT0spewogCQlpbnQgbGVuOwogCQlwcmludGsoS0VSTl9X
QVJOSU5HICJhYWNfc3JiX2NhbGxiYWNrOiBzcmIgZmFpbGVkLCBzdGF0dXMgPSAlZFxuIiwgbGUz
Ml90b19jcHUoc3JicmVwbHktPnN0YXR1cykpOwotCQlsZW4gPSAobGUzMl90b19jcHUoc3JicmVw
bHktPnNlbnNlX2RhdGFfc2l6ZSkgPiAKLQkJCQlTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpID8KLQkJ
CQlTQ1NJX1NFTlNFX0JVRkZFUlNJWkUgOgotCQkJCWxlMzJfdG9fY3B1KHNyYnJlcGx5LT5zZW5z
ZV9kYXRhX3NpemUpOworCQlsZW4gPSBtaW5fdCh1MzIsIGxlMzJfdG9fY3B1KHNyYnJlcGx5LT5z
ZW5zZV9kYXRhX3NpemUpLAorCQkgICAgICAgICAgICBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpOwog
CQlzY3NpY21kLT5yZXN1bHQgPSBESURfRVJST1IgPDwgMTYgfCBDT01NQU5EX0NPTVBMRVRFIDw8
IDggfCBTQU1fU1RBVF9DSEVDS19DT05ESVRJT047CiAJCW1lbWNweShzY3NpY21kLT5zZW5zZV9i
dWZmZXIsIHNyYnJlcGx5LT5zZW5zZV9kYXRhLCBsZW4pOwogCX0KQEAgLTI1MjcsMTAgKzI1MjEs
OCBAQAogCWlmIChsZTMyX3RvX2NwdShzcmJyZXBseS0+c2NzaV9zdGF0dXMpID09IDB4MDIgKXsg
IC8vIENoZWNrIENvbmRpdGlvbgogCQlpbnQgbGVuOwogCQlzY3NpY21kLT5yZXN1bHQgfD0gU0FN
X1NUQVRfQ0hFQ0tfQ09ORElUSU9OOwotCQlsZW4gPSAobGUzMl90b19jcHUoc3JicmVwbHktPnNl
bnNlX2RhdGFfc2l6ZSkgPiAKLQkJCQlTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpID8KLQkJCQlTQ1NJ
X1NFTlNFX0JVRkZFUlNJWkUgOgotCQkJCWxlMzJfdG9fY3B1KHNyYnJlcGx5LT5zZW5zZV9kYXRh
X3NpemUpOworCQlsZW4gPSBtaW5fdCh1MzIsIGxlMzJfdG9fY3B1KHNyYnJlcGx5LT5zZW5zZV9k
YXRhX3NpemUpLAorCQkgICAgICAgICAgICBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpOwogI2lmZGVm
IEFBQ19ERVRBSUxFRF9TVEFUVVNfSU5GTwogCQlwcmludGsoS0VSTl9XQVJOSU5HICJhYWNfc3Ji
X2NhbGxiYWNrOiBjaGVjayBjb25kaXRpb24sIHN0YXR1cyA9ICVkIGxlbj0lZFxuIiwKIAkJCQkJ
bGUzMl90b19jcHUoc3JicmVwbHktPnN0YXR1cyksIGxlbik7Cg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEA974ADPE2K703adapte_--
