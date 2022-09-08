Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BFFC38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 18:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiIHSQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiIHSQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 14:16:55 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D564FE2924
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 11:16:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id r18so12731208eja.11
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 11:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=pvbtmDWFw1+oebbNoWaOZ3pv66gdbjKsCPTlqgDvJRA=;
        b=J3NxVxe/8xObB/W+TxLUYyG+EUqUtr+GyWR3vxMM5H0bks0ctavZwaW9ymzkuCLI4T
         5kavRXXC2ArKECpSyGPVOTdlFkqBhrLHwFivgXZ9YxoLocWxe92pX1vNXUh3nQBLKnPd
         r0f5XwfNJ5zH3+HNZ5/HwQu8J6qUU05uVLWqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=pvbtmDWFw1+oebbNoWaOZ3pv66gdbjKsCPTlqgDvJRA=;
        b=S5zBP3OEG93qPVVyFLCfkYXYg5kR22Lg83ulgyKW9SvGt2VvbROmTkumotgnzzPeAO
         4PvxTjF3FkUP2htfxxAOZHIfv68tFKjHOW62ILhHxUKx6wEXXb1TunrVBkRSyzC9gFv1
         lvz6R4LOWrasYphea82LCYeKKuAhmMxUwRrURqLCzUkE5jvoHoXhA7GYaDpY51+GXrL2
         yZVFyn4v2tgWq6Z83xengCLeWHXCL1aMuoR64eVk14zt9wl9hz4EOf2o43F/V7LdUuHD
         gtFF1PLkGc6lG0pP2mHnh4o8TrFouuivMuJv/PQ76AiCJnzJKDMJAEsU38DBMCXOkZM0
         PiLA==
X-Gm-Message-State: ACgBeo2HeLDmOEQ/n+uGzffhUlXwNBtkyMg73Fj/xH5O7BJBvGNndcBG
        +fRt6Pvqo2p0KCY4lZnZY1OJuqzQeHeEe45T
X-Google-Smtp-Source: AA6agR4XSCA5MtE7vVDUFooB//YdiLIref7Kf6+l7vIok1+/G4NO+qcxCnfGblZw3KltU1qBRXU5Qw==
X-Received: by 2002:a17:907:60c7:b0:731:17e4:7fcc with SMTP id hv7-20020a17090760c700b0073117e47fccmr6977260ejc.73.1662661012168;
        Thu, 08 Sep 2022 11:16:52 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id y13-20020a50eb0d000000b00443d657d8a4sm12655133edp.61.2022.09.08.11.16.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 11:16:50 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id bz13so24106939wrb.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 11:16:49 -0700 (PDT)
X-Received: by 2002:adf:f484:0:b0:228:6489:5da3 with SMTP id
 l4-20020adff484000000b0022864895da3mr5937849wro.193.1662661009279; Thu, 08
 Sep 2022 11:16:49 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 8 Sep 2022 14:16:33 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
Message-ID: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
Subject: Re: PATCH] scsi: stex: properly zero out the passthrough command structure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hdthky <hdthky0@gmail.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: multipart/mixed; boundary="000000000000d74da105e82e6e75"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d74da105e82e6e75
Content-Type: text/plain; charset="UTF-8"

Sorry for bad message ID threading, but I don't have the original
email from Greg in my email, just a link to it on lore..

I'd suggest perhaps a slightly bigger patch than just adding the memset().

Something like the attached?

Entirely untested, but it would seem to be the cleaner way to go about this. No?

            Linus

--000000000000d74da105e82e6e75
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l7tdd2580>
X-Attachment-Id: f_l7tdd2580

IGRyaXZlcnMvc2NzaS9zdGV4LmMgICAgICB8IDE3ICsrKysrKysrKy0tLS0tLS0tCiBpbmNsdWRl
L3Njc2kvc2NzaV9jbW5kLmggfCAgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zdGV4LmMgYi9k
cml2ZXJzL3Njc2kvc3RleC5jCmluZGV4IGU2NDIwZjIxMjdjZS4uOGRlZjI0MjY3NWVmIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3Njc2kvc3RleC5jCisrKyBiL2RyaXZlcnMvc2NzaS9zdGV4LmMKQEAg
LTY2NSwxNiArNjY1LDE3IEBAIHN0YXRpYyBpbnQgc3RleF9xdWV1ZWNvbW1hbmRfbGNrKHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCkKIAkJcmV0dXJuIDA7CiAJY2FzZSBQQVNTVEhSVV9DTUQ6CiAJCWlm
IChjbWQtPmNtbmRbMV0gPT0gUEFTU1RIUlVfR0VUX0RSVlZFUikgewotCQkJc3RydWN0IHN0X2Ry
dnZlciB2ZXI7CisJCQljb25zdCBzdHJ1Y3Qgc3RfZHJ2dmVyIHZlciA9IHsKKwkJCQkubWFqb3Ig
PSBTVF9WRVJfTUFKT1IsCisJCQkJLm1pbm9yID0gU1RfVkVSX01JTk9SLAorCQkJCS5vZW0gPSBT
VF9PRU0sCisJCQkJLmJ1aWxkID0gU1RfQlVJTERfVkVSLAorCQkJCS5zaWduYXR1cmVbMF0gPSBQ
QVNTVEhSVV9TSUdOQVRVUkUsCisJCQkJLmNvbnNvbGVfaWQgPSBob3N0LT5tYXhfaWQgLSAxLAor
CQkJCS5ob3N0X25vID0gaGJhLT5ob3N0LT5ob3N0X25vLAorCQkJfTsKIAkJCXNpemVfdCBjcF9s
ZW4gPSBzaXplb2YodmVyKTsKIAotCQkJdmVyLm1ham9yID0gU1RfVkVSX01BSk9SOwotCQkJdmVy
Lm1pbm9yID0gU1RfVkVSX01JTk9SOwotCQkJdmVyLm9lbSA9IFNUX09FTTsKLQkJCXZlci5idWls
ZCA9IFNUX0JVSUxEX1ZFUjsKLQkJCXZlci5zaWduYXR1cmVbMF0gPSBQQVNTVEhSVV9TSUdOQVRV
UkU7Ci0JCQl2ZXIuY29uc29sZV9pZCA9IGhvc3QtPm1heF9pZCAtIDE7Ci0JCQl2ZXIuaG9zdF9u
byA9IGhiYS0+aG9zdC0+aG9zdF9ubzsKIAkJCWNwX2xlbiA9IHNjc2lfc2dfY29weV9mcm9tX2J1
ZmZlcihjbWQsICZ2ZXIsIGNwX2xlbik7CiAJCQlpZiAoc2l6ZW9mKHZlcikgPT0gY3BfbGVuKQog
CQkJCWNtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2OwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9zY3Np
L3Njc2lfY21uZC5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfY21uZC5oCmluZGV4IGJhYzU1ZGVjZjkw
MC4uN2QzNjIyZGIzOGVkIDEwMDY0NAotLS0gYS9pbmNsdWRlL3Njc2kvc2NzaV9jbW5kLmgKKysr
IGIvaW5jbHVkZS9zY3NpL3Njc2lfY21uZC5oCkBAIC0yMDEsNyArMjAxLDcgQEAgc3RhdGljIGlu
bGluZSB1bnNpZ25lZCBpbnQgc2NzaV9nZXRfcmVzaWQoc3RydWN0IHNjc2lfY21uZCAqY21kKQog
CWZvcl9lYWNoX3NnKHNjc2lfc2dsaXN0KGNtZCksIHNnLCBuc2VnLCBfX2kpCiAKIHN0YXRpYyBp
bmxpbmUgaW50IHNjc2lfc2dfY29weV9mcm9tX2J1ZmZlcihzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQs
Ci0JCQkJCSAgIHZvaWQgKmJ1ZiwgaW50IGJ1ZmxlbikKKwkJCQkJICAgY29uc3Qgdm9pZCAqYnVm
LCBpbnQgYnVmbGVuKQogewogCXJldHVybiBzZ19jb3B5X2Zyb21fYnVmZmVyKHNjc2lfc2dsaXN0
KGNtZCksIHNjc2lfc2dfY291bnQoY21kKSwKIAkJCQkgICBidWYsIGJ1Zmxlbik7Cg==
--000000000000d74da105e82e6e75--
