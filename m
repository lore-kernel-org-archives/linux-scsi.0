From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Mon, 14 May 2007 15:15:04 +0530
Message-ID: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:16805 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXENJpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 05:45:05 -0400
Received: by ik-out-1112.google.com with SMTP id b35so1039332ika
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 02:45:04 -0700 (PDT)
In-Reply-To: <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 5/14/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
>  config SCSI_WAIT_SCAN
>         tristate
> -       default m
> -       depends on SCSI
> -       depends on MODULES
> +       default m if SCSI=m
> +       default n

Note that this also means SCSI_WAIT_SCAN=n (will not get compiled
and built even as a module) if SCSI=y. But this is perfectly fine, because
I see:

#ifndef MODULE
late_initcall(scsi_complete_async_scans);
#endif

in drivers/scsi/scsi_scan.c anyway, so the async scans will be waited
upon and get complete even when SCSI=y and scsi_scan_type=async,
i.e. you don't really need the scsi_wait_scan module in that case anyway.

Satyam
