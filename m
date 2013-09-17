From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Does Linux support 32-byte CDBs
Date: Tue, 17 Sep 2013 12:19:51 -0700
Message-ID: <1379445591.32763.593.camel@haakon3.risingtidesystems.com>
References: <37a98d3f-3931-44c1-a76d-1fbdcfb4207f@googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38920 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IQTMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Sep 2013 15:12:10 -0400
In-Reply-To: <37a98d3f-3931-44c1-a76d-1fbdcfb4207f@googlegroups.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Falanga <af300wsm@gmail.com>

Hi Andrew,

(Adding CC' to linux-scsi, as it's a more appropriate venue than the
target list)

On Mon, 2013-09-16 at 13:27 -0700, Andrew Falanga wrote:
> Hello,
> 
> I truly hope that this is the correct forum for this question.  If
> not, forgive me and if possible, please direct me to the correct
> forum.  My question is quite simple (I hope the answer is equally
> simple).  Does Linux support 32-byte CDBs in SCSI?  I've done enough
> research that I think the answer may depend on the kernel version in
> use, and the particular upper layer driver in use (i.e. sd, sg, bsg,
> etc.).  If so, the relevant information from my linux system is:
> 
> * CentOS 6.2  -- 2.6.32-71 kernel  32-bit
> 
> I'd be using the SG driver.
> 

My understanding is that you need to use BSG in order to submit > 16
byte CDBs from userspace.

Also, sd.c will generate > 16 byte CDBs (eg: WRITE_32 + READ_32) when
DIF protection is enabled.

I believe that both are supported on v2.6.32.x, but you might want to
double check to be sure.

--nab


