Return-Path: <SRS0=DDJn=CA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FF6C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 20:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA43F207CD
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 20:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHVUnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Aug 2020 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgHVUna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2020 16:43:30 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Aug 2020 13:43:28 PDT
Received: from tartarus.angband.pl (tartarus.angband.pl [IPv6:2001:41d0:602:dbe::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A252C061573
        for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2020 13:43:28 -0700 (PDT)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1k9Zqr-0003yX-DW; Sat, 22 Aug 2020 22:10:57 +0200
Date:   Sat, 22 Aug 2020 22:10:57 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: build failure: aicasm: renamed yaccage
Message-ID: <20200822201057.GA14633@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!
My randconfig builds notoriously fail on this:

[~/linux/drivers/scsi/aic7xxx/aicasm](vanilla)$ make -j1
bison -d -b aicasm_gram aicasm_gram.y
mv aicasm_gram.tab.c .//aicasm_gram.c
mv aicasm_gram.tab.h .//aicasm_gram.h
bison -d -b aicasm_macro_gram -p mm aicasm_macro_gram.y
mv aicasm_macro_gram.tab.c .//aicasm_macro_gram.c
mv aicasm_macro_gram.tab.h .//aicasm_macro_gram.h
flex  -o aicasm_scan.c aicasm_scan.l
flex  -Pmm -o aicasm_macro_scan.c aicasm_macro_scan.l
cc -I/usr/include -I. -I./ aicasm.c aicasm_symbol.c .//aicasm_gram.c .//aicasm_macro_gram.c .//aicasm_scan.c .//aicasm_macro_scan.c -o .//aicasm -ldb
aicasm_symbol.c: In function ‘aic_print_reg_dump_end’:
aicasm_symbol.c:393:13: warning: implicit declaration of function ‘tolower’ [-Wimplicit-function-declaration]
  393 |   *letter = tolower(*letter);
      |             ^~~~~~~
aicasm_gram.tab.c:204:10: fatal error: aicasm_gram.tab.h: No such file or directory
compilation terminated.
aicasm_macro_gram.tab.c:167:10: fatal error: aicasm_macro_gram.tab.h: No such file or directory
compilation terminated.

And the generated yaccage has:
#include "aicasm_gram.tab.h"
which tries to refer to the just renamed file.

As the files in question are generated, with the filename coming from $YACC
rather than source, it'd take some after-processing with sed or a similar
hack.  Thus, instead of sending a patch, I thought it'd better to ask:
what the renames are for?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ It's time to migrate your Imaginary Protocol from version 4i to 6i.
⠈⠳⣄⠀⠀⠀⠀
