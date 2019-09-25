Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B286FC432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 19:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 813EA20640
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 19:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392307AbfIYTaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 15:30:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52599 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2387642AbfIYTaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Sep 2019 15:30:17 -0400
Received: (qmail 10811 invoked by uid 500); 25 Sep 2019 15:30:16 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 25 Sep 2019 15:30:16 -0400
Date:   Wed, 25 Sep 2019 15:30:16 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <981fc98a9995eaee5f65709cacc46f13a2c603ad.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1909251524520.6072-300000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1609956864-621808940-1569439816=:6072"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1609956864-621808940-1569439816=:6072
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 20 Sep 2019, Andrea Vai wrote:

> Il giorno gio, 19/09/2019 alle 14.14 +0000, Damien Le Moal ha scritto:
> > On 2019/09/19 16:01, Alan Stern wrote:
> > [...]
> > > No doubt Andrea will be happy to test your fix when it's ready.
> 
> Yes, of course.
> 
> > 
> > Hannes posted an RFC series:
> > 
> > https://www.spinics.net/lists/linux-scsi/msg133848.html
> > 
> > Andrea can try it.
> 
> Ok, but I would need some instructions please, because I am not able
> to understand how to "try it". Sorry for that.

I have attached the two patches to this email.  You should start with a 
recent kernel source tree and apply the patches by doing:

	git apply patch1 patch2

or something similar.  Then build a kernel from the new source code and 
test it.

Ultimately, if nobody can find a way to restore the sequential I/O 
behavior we had prior to commit f664a3cc17b7, that commit may have to 
be reverted.

Alan Stern

---1609956864-621808940-1569439816=:6072
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=patch1
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.1909251530160.6072@netrider.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename=patch1

RnJvbTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPg0KDQpXaGVu
IGJsa19tcV9yZXF1ZXN0X2lzc3VlX2RpcmVjdGx5KCkgcmV0dXJucyBCTEtf
U1RTX1JFU09VUkNFIHdlDQpuZWVkIHRvIHJlcXVldWUgdGhlIEkvTywgYnV0
IGFkZGluZyBpdCB0byB0aGUgZ2xvYmFsIHJlcXVlc3QgbGlzdA0Kd2lsbCBt
ZXNzIHVwIHdpdGggdGhlIHBhc3NlZC1pbiByZXF1ZXN0IGxpc3QuIFNvIHJl
LWFkZCB0aGUgcmVxdWVzdA0KdG8gdGhlIG9yaWdpbmFsIGxpc3QgYW5kIGxl
YXZlIGl0IHRvIHRoZSBjYWxsZXIgdG8gaGFuZGxlIHNpdHVhdGlvbnMNCndo
ZXJlIHRoZSBsaXN0IHdhc24ndCBjb21wbGV0ZWx5IGVtcHRpZWQuDQoNClNp
Z25lZC1vZmYtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4N
Ci0tLQ0KIGJsb2NrL2Jsay1tcS5jIHwgMyArLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1n
aXQgYS9ibG9jay9ibGstbXEuYyBiL2Jsb2NrL2Jsay1tcS5jDQppbmRleCBi
MDM4ZWM2ODBlODQuLjQ0ZmYzYzE0NDJhNCAxMDA2NDQNCi0tLSBhL2Jsb2Nr
L2Jsay1tcS5jDQorKysgYi9ibG9jay9ibGstbXEuYw0KQEAgLTE4OTksOCAr
MTg5OSw3IEBAIHZvaWQgYmxrX21xX3RyeV9pc3N1ZV9saXN0X2RpcmVjdGx5
KHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LA0KIAkJaWYgKHJldCAhPSBC
TEtfU1RTX09LKSB7DQogCQkJaWYgKHJldCA9PSBCTEtfU1RTX1JFU09VUkNF
IHx8DQogCQkJCQlyZXQgPT0gQkxLX1NUU19ERVZfUkVTT1VSQ0UpIHsNCi0J
CQkJYmxrX21xX3JlcXVlc3RfYnlwYXNzX2luc2VydChycSwNCi0JCQkJCQkJ
bGlzdF9lbXB0eShsaXN0KSk7DQorCQkJCWxpc3RfYWRkKGxpc3QsICZycS0+
cXVldWVsaXN0KTsNCiAJCQkJYnJlYWs7DQogCQkJfQ0KIAkJCWJsa19tcV9l
bmRfcmVxdWVzdChycSwgcmV0KTsNCi0tIA0KMi4xNi40DQo=
---1609956864-621808940-1569439816=:6072
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=patch2
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.1909251530161.6072@netrider.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename=patch2

RnJvbTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPg0KDQpBIHNj
aGVkdWxlciBtaWdodCBiZSBhdHRhY2hlZCBldmVuIGZvciBkZXZpY2VzIGV4
cG9zaW5nIG1vcmUgdGhhbg0Kb25lIGhhcmR3YXJlIHF1ZXVlLCBzbyB0aGUg
Y2hlY2sgZm9yIHRoZSBudW1iZXIgb2YgaGFyZHdhcmUgcXVldWUNCmlzIHBv
aW50bGVzcyBhbmQgc2hvdWxkIGJlIHJlbW92ZWQuDQoNClNpZ25lZC1vZmYt
Ynk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4NCi0tLQ0KIGJs
b2NrL2Jsay1tcS5jIHwgNiArLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9i
bG9jay9ibGstbXEuYyBiL2Jsb2NrL2Jsay1tcS5jDQppbmRleCA0NGZmM2Mx
NDQyYTQuLmZhYWI1NDJlNDgzNiAxMDA2NDQNCi0tLSBhL2Jsb2NrL2Jsay1t
cS5jDQorKysgYi9ibG9jay9ibGstbXEuYw0KQEAgLTE5MzEsNyArMTkzMSw2
IEBAIHN0YXRpYyB2b2lkIGJsa19hZGRfcnFfdG9fcGx1ZyhzdHJ1Y3QgYmxr
X3BsdWcgKnBsdWcsIHN0cnVjdCByZXF1ZXN0ICpycSkNCiANCiBzdGF0aWMg
YmxrX3FjX3QgYmxrX21xX21ha2VfcmVxdWVzdChzdHJ1Y3QgcmVxdWVzdF9x
dWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvKQ0KIHsNCi0JY29uc3QgaW50IGlz
X3N5bmMgPSBvcF9pc19zeW5jKGJpby0+Ymlfb3BmKTsNCiAJY29uc3QgaW50
IGlzX2ZsdXNoX2Z1YSA9IG9wX2lzX2ZsdXNoKGJpby0+Ymlfb3BmKTsNCiAJ
c3RydWN0IGJsa19tcV9hbGxvY19kYXRhIGRhdGEgPSB7IC5mbGFncyA9IDB9
Ow0KIAlzdHJ1Y3QgcmVxdWVzdCAqcnE7DQpAQCAtMTk3Nyw3ICsxOTc2LDcg
QEAgc3RhdGljIGJsa19xY190IGJsa19tcV9tYWtlX3JlcXVlc3Qoc3RydWN0
IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBiaW8gKmJpbykNCiAJCS8qIGJ5
cGFzcyBzY2hlZHVsZXIgZm9yIGZsdXNoIHJxICovDQogCQlibGtfaW5zZXJ0
X2ZsdXNoKHJxKTsNCiAJCWJsa19tcV9ydW5faHdfcXVldWUoZGF0YS5oY3R4
LCB0cnVlKTsNCi0JfSBlbHNlIGlmIChwbHVnICYmIChxLT5ucl9od19xdWV1
ZXMgPT0gMSB8fCBxLT5tcV9vcHMtPmNvbW1pdF9ycXMpKSB7DQorCX0gZWxz
ZSBpZiAocGx1ZyAmJiBxLT5tcV9vcHMtPmNvbW1pdF9ycXMpIHsNCiAJCS8q
DQogCQkgKiBVc2UgcGx1Z2dpbmcgaWYgd2UgaGF2ZSBhIC0+Y29tbWl0X3Jx
cygpIGhvb2sgYXMgd2VsbCwgYXMNCiAJCSAqIHdlIGtub3cgdGhlIGRyaXZl
ciB1c2VzIGJkLT5sYXN0IGluIGEgc21hcnQgZmFzaGlvbi4NCkBAIC0yMDIw
LDkgKzIwMTksNiBAQCBzdGF0aWMgYmxrX3FjX3QgYmxrX21xX21ha2VfcmVx
dWVzdChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlv
KQ0KIAkJCWJsa19tcV90cnlfaXNzdWVfZGlyZWN0bHkoZGF0YS5oY3R4LCBz
YW1lX3F1ZXVlX3JxLA0KIAkJCQkJJmNvb2tpZSk7DQogCQl9DQotCX0gZWxz
ZSBpZiAoKHEtPm5yX2h3X3F1ZXVlcyA+IDEgJiYgaXNfc3luYykgfHwgKCFx
LT5lbGV2YXRvciAmJg0KLQkJCSFkYXRhLmhjdHgtPmRpc3BhdGNoX2J1c3kp
KSB7DQotCQlibGtfbXFfdHJ5X2lzc3VlX2RpcmVjdGx5KGRhdGEuaGN0eCwg
cnEsICZjb29raWUpOw0KIAl9IGVsc2Ugew0KIAkJYmxrX21xX3NjaGVkX2lu
c2VydF9yZXF1ZXN0KHJxLCBmYWxzZSwgdHJ1ZSwgdHJ1ZSk7DQogCX0NCi0t
IA0KMi4xNi40DQo=
---1609956864-621808940-1569439816=:6072--
