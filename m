Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175BCC433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 11:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60246115B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 11:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhDIL2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 07:28:12 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.132]:13179 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhDIL2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 07:28:11 -0400
X-Greylist: delayed 719 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2021 07:28:11 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1617966957; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LMrmZPF1aNmZ3JIWvv+6OO+/WmBvBUGGw8/e5ykXMylsuPhSlzNg63TSEexg4zioOM
    5wMoxr5OD462Jv6mgirdfrAr8BqznvchyIua9nSPA4HNnRo+f5lvAcgqBxWAujACuw88
    tcmdpKWLTrhZspFSbXtmyzLHdq3wkibkv6NOD6R7TLLM9RmOTKytlGCeO5deK9Gc/oOp
    KbNS84CpdyhoDHT+RkK49kLfP5gZT7IzcMPL8kL96XC01DGsiPgJk2rSRKtznWVqQ+bw
    MIdlMhPDGHLegydRpAULe3UrvfkRRgUSRU8fR4ilVODR4iKSrqn3lvSx3SkcbUYTPkGu
    593g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617966957;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Subject:To:From:Date:Cc:Date:From:Subject:Sender;
    bh=G0iBoAoerbL80Lk116UXYLdUYiopGcAZoZWiEH2Mj3E=;
    b=iF12Q3YvaMuRg5io+uwAEtlDGThW/kAkPxCCz186+gIwBQvh9c7HACy9pJCx5gtqoJ
    qd1wvR3JzG/rMn2Kgl4qhn8HXnu1Zm2lRHacE/yLBNbvCnVa8/CFd+6S7NyOMAqp2eVv
    j3UeJNKfSsgqs9JsxfTljFmBPbM2Y+JegqB7kn9oLABkfDBS1PahYEPN0LZAXovCOSTE
    iTtGOKznd+p0m7Fqu548uhklTnJ6cKQsmE7QGOoiHZzcrT8cgCW8WPraLuqF1hxYQNz5
    YIwVqLOLbbt67HTENUxItsPBSz5BxGLEeRTi6WXW5cH7SbwrJExVvsSsQnc0mbDxK1NI
    eNUw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617966957;
    s=strato-dkim-0002; d=sicyon-risk.com;
    h=Message-ID:Subject:To:From:Date:Cc:Date:From:Subject:Sender;
    bh=G0iBoAoerbL80Lk116UXYLdUYiopGcAZoZWiEH2Mj3E=;
    b=OT4VTvMoUCs2HHjhyzlkHzeGiRUvo2qTN+IlV0243W9KC3p0cPsIcpWGR99/RWWgB3
    O1QJCxDbp/y4EEii5Jr+WqV9TblTKUZnUgKTRaOhpOzKp3o2GGd/1vVD+lgjRbebnH+4
    1UmdS2o2CcN36isCdYj9geb6ye4+QKvyXO+8tVgaZkuG3QGwaxoNc5EoduY7MkGt2TtC
    ui3+D23g2MGWrRHj2c0xT/FmuYL7c1dB2tNPzNXa3XVctVpJDKBM6iNRdBhhtv6cwZI6
    bVzcwkGlRug/npOVJ/9wC32Rc0KGofpN0sNiH9sLTWk8anz5ScPRlJbjQcEg5XirXmrW
    170g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":O2kGeEG7b/pS1F6wSGa8hypi1jz+LakDa8GkBwDfiOkn+PVe8UaYb7dXkqfhKW2vc0Z1VGoMfmH3d/cMH6I="
X-RZG-CLASS-ID: mo05
Received: from mail.computerdu.de
    by smtp.strato.com (RZmta 47.24.0 DYNA|AUTH)
    with ESMTPSA id j05debx39BFv7uA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate)
    for <linux-scsi@vger.kernel.org>;
    Fri, 9 Apr 2021 13:15:57 +0200 (CEST)
Received: from localhost (unknown [127.0.0.1])
        by mail.computerdu.de (Postfix) with ESMTP id 6805D4C0958
        for <linux-scsi@vger.kernel.org>; Fri,  9 Apr 2021 13:15:54 +0200 (CEST)
Received: from mail.computerdu.de ([127.0.0.1])
        by localhost (mail.computerdu.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id SWSWHaK_4Jsg for <linux-scsi@vger.kernel.org>;
        Fri,  9 Apr 2021 13:15:50 +0200 (CEST)
Received: from taurus.nifty.lan (unknown [192.168.0.106])
        by mail.computerdu.de (Postfix) with ESMTPSA id 4FF864C0957
        for <linux-scsi@vger.kernel.org>; Fri,  9 Apr 2021 13:15:50 +0200 (CEST)
Date:   Fri, 9 Apr 2021 13:15:51 +0200
From:   Daniel Hiepler <d-linux@coderdu.de>
To:     linux-scsi@vger.kernel.org
Subject: aic7xxx seems broken
Message-ID: <20210409131551.75114346@taurus.nifty.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

i tried to get my old Adaptec AHA-2940W/2940UW controller working to read some
old disks. This controller needs firmware compiled to work (i.e. it doesn't
detect any disks without firmware compiled).

Compiling fails [1] (This is a kernel with gentoo patchset but I also tried with
vanilla, without luck). I think it's related to this lkml post [2].

I hope this is fixable and this is the right place to report. If I should
report somewhere else, I'd appreciate if someone could point it out.


Best Regards


[1]
---------------------------------------------------
make -C ./drivers/scsi/aic7xxx/aicasm OUTDIR=/mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm/
gcc -I/usr/include -I. -I/mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm/ aicasm.c aicasm_symbol.c /mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/
aicasm//aicasm_gram.c /mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm//aicasm_macro_gram.c /mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm//
aicasm_scan.c /mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm//aicasm_macro_scan.c -o /mnt/hdd/usr/src/linux-5.11.11-gentoo/drivers/scsi/aic7xxx/aicasm//aicas
m -ldb
aicasm_symbol.c: In function 'aic_print_reg_dump_end':
aicasm_symbol.c:393:13: warning: implicit declaration of function 'tolower' [-Wimplicit-function-declaration]
  393 |   *letter = tolower(*letter);
      |             ^~~~~~~
aicasm_gram.tab.c:204:10: fatal error: aicasm_gram.tab.h: No such file or directory
compilation terminated.
aicasm_macro_gram.tab.c:167:10: fatal error: aicasm_macro_gram.tab.h: No such file or directory
compilation terminated.
aicasm_scan.l: In function 'yylex':
aicasm_scan.l:417:6: warning: implicit declaration of function 'mm_switch_to_buffer'; did you mean 'yy_switch_to_buffer'? [-Wimplicit-function-declaration]
  417 |      mm_switch_to_buffer(old_state);
      |      ^~~~~~~~~~~~~~~~~~~
      |      yy_switch_to_buffer
aicasm_scan.l:418:6: warning: implicit declaration of function 'mmparse'; did you mean 'yyparse'? [-Wimplicit-function-declaration]
  418 |      mmparse();
      |      ^~~~~~~
      |      yyparse
aicasm_scan.l:421:6: warning: implicit declaration of function 'mm_delete_buffer'; did you mean 'yy_delete_buffer'? [-Wimplicit-function-declaration]
  421 |      mm_delete_buffer(temp_state);
      |      ^~~~~~~~~~~~~~~~
      |      yy_delete_buffer
make[4]: *** [Makefile:39: aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/Makefile:87: drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [scripts/Makefile.build:496: drivers/scsi/aic7xxx] Error 2
make[1]: *** [scripts/Makefile.build:496: drivers/scsi] Error 2
make: *** [Makefile:1809: drivers] Error 2
make: *** Waiting for unfinished jobs....
---------------------------------------------------

[2] https://lkml.org/lkml/2020/8/22/285


-- 
Daniel Hiepler


