From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: bug report: fusion: odd range check in mptbase
Date: Wed, 31 Mar 2010 18:18:44 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E3948E6@inbmail02.lsi.com>
References: <20100328112656.GN5069@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36770 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932682Ab0CaMtA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2010 08:49:00 -0400
In-Reply-To: <20100328112656.GN5069@bicker>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Support, Software" <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dan,

This catch is correct. I would rework and post the patch to upstream.

Thanks,
Kashyap

> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Sunday, March 28, 2010 4:57 PM
> To: Moore, Eric
> Cc: Support, Software; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: bug report: fusion: odd range check in mptbase
> 
> Hi, I'm just going through some Smatch results and couldn't figure out
> what to do with this:
> 
> drivers/message/fusion/mptbase.c +7850 mpt_sas_log_info()
> 'originator_str' 3 <= 3
>   7846          if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
>   7847              (sas_loginfo.dw.originator <
> ARRAY_SIZE(originator_str)))
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
>   7848                  return;
>   7849
>   7850          originator_desc =
> originator_str[sas_loginfo.dw.originator];
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> If sas_loginfo.dw.originator is == ARRAY_SIZE(originator_str) that
> would
> be a buffer overflow on line 7850.
> 
> regards,
> dan carpenter
