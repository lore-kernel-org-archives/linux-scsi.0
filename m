From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 3/3] scsi: proper state checking and module refcount
 handling in scsi_device_get
Date: Wed, 29 Apr 2015 10:17:59 +0900
Message-ID: <CAC5umyiSEmBOLT2MeztTq8z5-wE3koXpRQkD+tuX8b-PMg-e+A@mail.gmail.com>
References: <1422882086-1863-1-git-send-email-hch@lst.de>
	<1422882086-1863-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134635af597730514d2bfa2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33654 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031319AbbD2BSB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2015 21:18:01 -0400
Received: by lbbzk7 with SMTP id zk7so9323741lbb.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2015 18:17:59 -0700 (PDT)
In-Reply-To: <1422882086-1863-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

--001a1134635af597730514d2bfa2
Content-Type: text/plain; charset=UTF-8

2015-02-02 22:01 GMT+09:00 Christoph Hellwig <hch@lst.de>:
> This effectively reverts commits 85b6c7 ("[SCSI] sd: fix cache flushing on
> module removal (and individual device removal)" and dc4515ea ("scsi: always
> increment reference count").
>
> We now never call scsi_device_get from the shutdown path, and the fact
> that we started grabbing reference there in commit 85b6c7 turned out
> turned out to create more problems than it solves, and required
> workarounds for workarounds for workarounds. Move back to properly checking
> the device state and carefully handle module refcounting.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 9b38299..9b7fd0b 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -979,18 +979,24 @@ EXPORT_SYMBOL(scsi_report_opcode);
>   * Description: Gets a reference to the scsi_device and increments the use count
>   * of the underlying LLDD module.  You must hold host_lock of the
>   * parent Scsi_Host or already have a reference when calling this.
> + *
> + * This will fail if a device is deleted or cancelled, or when the LLD module
> + * is in the process of being unloaded.
>   */
>  int scsi_device_get(struct scsi_device *sdev)

Hi Christoph,

This change broke ufs driver.

Because scsi_device_get() can be called while the module is being
unloaded with the device runtime suspended.
(i.e. driver_detach -> ... pm_runtime_get_sync() ... ->
ufshcd_runtime_resume -> ufshcd_resume -> ufshcd_set_dev_pwr_mode ->
scsi_device_get -> try_module_get -> return -ENXIO)

The reason for scsi_device_get() in ufshcd_set_dev_pwr_mode() is
to avoid manual delete of UFS device W-LUN by holding the reference
to it.  So can we acquire shost->scan_mutex lock instead of
scsi_device_get()?  I tried attached patch and it seems to be working,
but I would like to ask your opinion about this change.

>  {
> -       if (sdev->sdev_state == SDEV_DEL)
> -               return -ENXIO;
> +       if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
> +               goto fail;
>         if (!get_device(&sdev->sdev_gendev))
> -               return -ENXIO;
> -       /* We can fail try_module_get if we're doing SCSI operations
> -        * from module exit (like cache flush) */
> -       __module_get(sdev->host->hostt->module);
> -
> +               goto fail;
> +       if (!try_module_get(sdev->host->hostt->module))
> +               goto fail_put_device;
>         return 0;
> +
> +fail_put_device:
> +       put_device(&sdev->sdev_gendev);
> +fail:
> +       return -ENXIO;
>  }
>  EXPORT_SYMBOL(scsi_device_get);
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--001a1134635af597730514d2bfa2
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-scsi-ufs-fix-ufshcd_set_dev_pwr_mode-when-unloading-.patch"
Content-Disposition: attachment;
	filename="0001-scsi-ufs-fix-ufshcd_set_dev_pwr_mode-when-unloading-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i921x3yw0

RnJvbSBhMzA1YTUyODRjYWMyM2FkYmY3Zjg2YjMwMTRjYzJlNjMyNWM3Yjg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBa2lub2J1IE1pdGEgPGFraW5vYnUubWl0YUBnbWFpbC5jb20+
CkRhdGU6IFdlZCwgMjkgQXByIDIwMTUgMTA6MDI6MTcgKzA5MDAKU3ViamVjdDogW1BBVENIXSBz
Y3NpOiB1ZnM6IGZpeCB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZSgpIHdoZW4gdW5sb2FkaW5nCiBt
b2R1bGUKCi0tLQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDE4ICsrKysrKystLS0tLS0t
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMKaW5kZXggNTQwZTAwZC4uOTFjYmMwNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYworKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jCkBAIC00Njk1LDIz
ICs0Njk1LDE5IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoc3RydWN0IHVm
c19oYmEgKmhiYSwKIAlzdHJ1Y3Qgc2NzaV9zZW5zZV9oZHIgc3NoZHI7CiAJc3RydWN0IHNjc2lf
ZGV2aWNlICpzZHA7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKLQlpbnQgcmV0OworCWludCByZXQg
PSAwOwogCisJbXV0ZXhfbG9jaygmaGJhLT5ob3N0LT5zY2FuX211dGV4KTsKIAlzcGluX2xvY2tf
aXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwogCXNkcCA9IGhiYS0+c2Rldl91
ZnNfZGV2aWNlOwotCWlmIChzZHApIHsKLQkJcmV0ID0gc2NzaV9kZXZpY2VfZ2V0KHNkcCk7Ci0J
CWlmICghcmV0ICYmICFzY3NpX2RldmljZV9vbmxpbmUoc2RwKSkgewotCQkJcmV0ID0gLUVOT0RF
VjsKLQkJCXNjc2lfZGV2aWNlX3B1dChzZHApOwotCQl9Ci0JfSBlbHNlIHsKKwlpZiAoIXNkcCB8
fCAhc2NzaV9kZXZpY2Vfb25saW5lKHNkcCkpCiAJCXJldCA9IC1FTk9ERVY7Ci0JfQogCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAotCWlmIChy
ZXQpCisJaWYgKHJldCkgeworCQltdXRleF91bmxvY2soJmhiYS0+aG9zdC0+c2Nhbl9tdXRleCk7
CiAJCXJldHVybiByZXQ7CisJfQogCiAJLyoKIAkgKiBJZiBzY3NpIGNvbW1hbmRzIGZhaWwsIHRo
ZSBzY3NpIG1pZC1sYXllciBzY2hlZHVsZXMgc2NzaSBlcnJvci0KQEAgLTQ3NDgsNyArNDc0NCw3
IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoc3RydWN0IHVmc19oYmEgKmhi
YSwKIAlpZiAoIXJldCkKIAkJaGJhLT5jdXJyX2Rldl9wd3JfbW9kZSA9IHB3cl9tb2RlOwogb3V0
OgotCXNjc2lfZGV2aWNlX3B1dChzZHApOworCW11dGV4X3VubG9jaygmaGJhLT5ob3N0LT5zY2Fu
X211dGV4KTsKIAloYmEtPmhvc3QtPmVoX25vcmVzdW1lID0gMDsKIAlyZXR1cm4gcmV0OwogfQot
LSAKMS45LjEKCg==
--001a1134635af597730514d2bfa2--
