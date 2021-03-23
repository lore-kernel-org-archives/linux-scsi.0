Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E14C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 07:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0F6619BA
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 07:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhCWHYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 03:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCWHYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 03:24:20 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2ABC061574;
        Tue, 23 Mar 2021 00:24:20 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id 94so14311410qtc.0;
        Tue, 23 Mar 2021 00:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FR181K9vED9jYA3wKRdAjKkm216lNGd88qtjMEThTfA=;
        b=Nnm7PsdSc2Z66JalAEpbAotT6dWiZYmyk2PyJslK18qMuROkLqKZHIupoWLYkvgL+Z
         P9Y1+XttyHwZvMFMJWQKpmYesaEH8y+q+/PT4V5secUmc40vBmnXw7Y8tBo4M7P4OE2j
         0dYz7CdLWCNtX0WrSAJalzisTb+/J2e9D9r3VhMp8NUshUG4gNY48wZ/1W61ULJNJXpI
         6ETsY/G0aQFBU2QH8E7SAbAzzd2XF+BI8ANiAfREdzgqWxTM9PlhORRAJe6dpfyHrEzI
         DGvYfxVjDY5CRdq0NXdiHDCdY1Uf/DOmLZSoyYJMzJagYqxgzsG7K4h52PHOMBiat/J0
         wLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FR181K9vED9jYA3wKRdAjKkm216lNGd88qtjMEThTfA=;
        b=msd7sqMPyXwFrppKPreC+5f1sOUOXP7se04peRcJndsZ/s9y3Rde+eojmqqQ6kwrFu
         dgFeRUSs5VXkbbR/dStfy6yh1/nJPPXNSoX+zpVK+fhjAp1uLtpTvDuXgdBs+GXnsjkd
         RK7silfs4jVYvYWoWmkR1aUml89U017iNupNbmZZJ1Eoq6YTl9/MWXFLfJVSd+avpqDZ
         pp/sY4exW1TFegtRxDjbzuYk5YYmnRHewW3nvzJsgekuYzyaOtPRSEQsWnBC+YX6fRNR
         PVud5LcDSUYIjz9XGBcDErg3Q0hFNTb2uPaPqCCOV4i2dFZzvZvPqB6gDRvSohEMqoxX
         s7yA==
X-Gm-Message-State: AOAM5315CCCvEhA94ll42rrFlsszgHsDBZ3JRC2R1R+FbloiwjYYJRrt
        W7j84v7hN08JnRKbe6DhMadnT77naMe41JuUHqM=
X-Google-Smtp-Source: ABdhPJzEYfvSiCxdBnzf5XRhinZekJo3FbbGbttMqeobbZWA5tuODsu9T4NbuXuewf0s35OuyPZSv/1hNfE5UVtOS0o=
X-Received: by 2002:ac8:7f4e:: with SMTP id g14mr3260607qtk.35.1616484259937;
 Tue, 23 Mar 2021 00:24:19 -0700 (PDT)
MIME-Version: 1.0
From:   Du Dengke <pinganddu90@gmail.com>
Date:   Tue, 23 Mar 2021 15:24:08 +0800
Message-ID: <CAKHP1duT_jQ6pA7WnHPiYvoQvu1vVmAgUDp1kjhnngRufgijgA@mail.gmail.com>
Subject: __scsi_remove_device: fix comments minor error
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000019598005be2f12ba"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000019598005be2f12ba
Content-Type: text/plain; charset="UTF-8"

Hi experts:
    When I read scsi kernel code, I found a spell error in
__scsi_remove_device function comments. Patch was made in attach file.
Thanks
//dengke

--00000000000019598005be2f12ba
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-__scsi_remove_device-fix-comments-minor-error.patch"
Content-Disposition: attachment; 
	filename="0001-__scsi_remove_device-fix-comments-minor-error.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmloymn70>
X-Attachment-Id: f_kmloymn70

RnJvbSA0MjBlMDUxYjYyNGM4MWQyOTg1NjRjNDE2YjVhOTYxODhkZDBiYjZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBkdWRlbmdrZSA8ZGVuZ2tlLmR1QHVjYXMuY29tLmNuPgpEYXRl
OiBUdWUsIDIzIE1hciAyMDIxIDEwOjU3OjA3ICswODAwClN1YmplY3Q6IFtQQVRDSF0gX19zY3Np
X3JlbW92ZV9kZXZpY2U6IGZpeCBjb21tZW50cyBtaW5vciBlcnJvcgoKU2lnbmVkLW9mZi1ieTog
ZHVkZW5na2UgPGRlbmdrZS5kdUB1Y2FzLmNvbS5jbj4KLS0tCiBkcml2ZXJzL3Njc2kvc2NzaV9z
eXNmcy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYyBiL2RyaXZlcnMvc2Nz
aS9zY3NpX3N5c2ZzLmMKaW5kZXggYjYzNzhjOGNhNzgzLi44NmU4ZDBiZjgyMWQgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfc3lz
ZnMuYwpAQCAtMTQ1OCw3ICsxNDU4LDcgQEAgdm9pZCBfX3Njc2lfcmVtb3ZlX2RldmljZShzdHJ1
Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCiAKIAkvKgogCSAqIFBhaXJlZCB3aXRoIHRoZSBrcmVmX2dl
dCgpIGluIHNjc2lfc3lzZnNfaW5pdGlhbGl6ZSgpLiAgV2UgaGF2ZQotCSAqIHJlbW9lZCBzeXNm
cyB2aXNpYmlsaXR5IGZyb20gdGhlIGRldmljZSwgc28gbWFrZSB0aGUgdGFyZ2V0CisJICogcmVt
b3ZlZCBzeXNmcyB2aXNpYmlsaXR5IGZyb20gdGhlIGRldmljZSwgc28gbWFrZSB0aGUgdGFyZ2V0
CiAJICogaW52aXNpYmxlIGlmIHRoaXMgd2FzIHRoZSBsYXN0IGRldmljZSB1bmRlcm5lYXRoIGl0
LgogCSAqLwogCXNjc2lfdGFyZ2V0X3JlYXAoc2NzaV90YXJnZXQoc2RldikpOwotLSAKMi4yNS4x
Cgo=
--00000000000019598005be2f12ba--
