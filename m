From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 16:40:10 +0200
Message-ID: <4A3A51CA.90803@gmail.com>
References: <4A3A2FA2.60005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42307 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZFRMj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 08:39:56 -0400
Received: by ewy6 with SMTP id 6so1497962ewy.37
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 05:39:57 -0700 (PDT)
In-Reply-To: <4A3A2FA2.60005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Op 18-06-09 14:14, Roel Kluin schreef:
> Shifting of u8 causes promotion to signed 'int'
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I believe this was not intentionally?
> see http://osdir.com/ml/git/2009-06/msg01347.html
 ResidCnt = (((u32) DC390_read8 (CtcReg_High) << 16) |

Maybe my patch is not right. I cannot reproduce it with:

#include <stdio.h>

int main()
{
	unsigned long size = 0;
	unsigned char c = 1;

	size += c << 24;

	printf("%lu\n", size);
	printf("%lu\n", 1 << 24);
	printf("%u\n", c);
	return 0;
}

[roel@zoinx linux-git]$ ./a.out
16777216
16777216
1

Roel
