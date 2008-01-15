From: "Grant Grundler" <grundler@google.com>
Subject: Re: MPT Fusion initialization in 2.6.23.12
Date: Mon, 14 Jan 2008 16:41:57 -0800
Message-ID: <da824cf30801141641u7baac682haa1ff06dddc5da99@mail.gmail.com>
References: <20080111140120.GA2116@synapse.neuralscape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:32944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYAOAmJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 19:42:09 -0500
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id m0F0fwD5009888
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 00:41:59 GMT
Received: from py-out-1112.google.com (pyia25.prod.google.com [10.34.253.25])
	by zps38.corp.google.com with ESMTP id m0F0fvxu009195
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 16:41:58 -0800
Received: by py-out-1112.google.com with SMTP id a25so2905276pyi.11
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 16:41:57 -0800 (PST)
In-Reply-To: <20080111140120.GA2116@synapse.neuralscape.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Shaeffer <shaeffer@neuralscape.com>
Cc: linux-scsi@vger.kernel.org

On Jan 11, 2008 6:01 AM, Karen Shaeffer <shaeffer@neuralscape.com> wrote:
> Hi,
>
> I have this server with an LSI Logic SAS1064 RAID
> enabled Ultra320 SCSI controller on the system board.

Karen,
The above doesn't make sense to me. How is "SAS 1064 RAID" related to
"Ultra320 SCSI"?
This card has both traditional 68-pin VHDLC connector and SAS/SATA connector?
Is the word "and" missing from the above?


> I am running a vanilla 2.6.23.12 kernel. Everything
> runs well, except during the boot I see these logs
> in dmesg and the syslogs.
>
> mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000001h

My interpretation of this (and Eric should know this alot better) is
the host is attempting to
read (action=01h) this page (type 08h ==
MPI_CONFIG_PAGETYPE_RAID_VOLUME) and couldn't.
ie maybe HW RAID isn't configured on the card?

Similarly, if this is being reported for a "normal" LSI u320 scsi controller
which doesn't support RAID, then perhaps the mpt driver should "learn"
it doesn't need to query this page.

> I've traced through the mptbase.c code and can see these
> invalid config pages are read from the controller during
> initialization.

My guess is it's reported as an error because the bhost attempted to
read them but couldn't.

hth,
grant

> This doesn't appear to cause any ill
> effects, but I am wondering how to resolve this? Maybe
> a MPT BIOS or MPT firmware upgrade will fix this?
>
> Thanks,
> Karen
> --
>  Karen Shaeffer
>  Neuralscape, Palo Alto, Ca. 94306
>  shaeffer@neuralscape.com  http://www.neuralscape.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
