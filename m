From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 00/12] scsi_debug: multiple queue support and cleanup
Date: Fri, 29 Apr 2016 22:06:03 -0400
Message-ID: <5724130B.8060001@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <yq1d1p89dlp.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46872 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbcD3CGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 22:06:15 -0400
In-Reply-To: <yq1d1p89dlp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, tomas.winkler@intel.com, emilne@redhat.com

On 2016-04-29 07:53 PM, Martin K. Petersen wrote:
>>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:
>
> Doug> Primary reason for this patch series is to add multi queue support
> Doug> modelled on the null_blk driver. Ignore host_lock option but keep
> Doug> parameter for backward compatibility. Use high resolution timers
> Doug> to implement both the jiffy and nanosecond delay
> Doug> parameters. Replace the tasklets with work items. Incorporate
> Doug> REPORT LUNS patch from Tomas Winkler sent in Febrary 2015. Add
> Doug> parameter that permits LU names to use UUIDs (spc5r08.pdf).
>
> I applied 1-7 with minor fixes based on the comments. Sounds like 8 and
> 9 need a bit of tweaking. 10-12 look fine but don't apply out of order.

Version 2 of that patchset should appear before this post. I forgot
to note that they had all been acked by Hannes Reinecke apart from
8/12 "rework resp_report_luns". Hopefully his concerns have been
address in v2 (new patch needed for the extras he wanted).

I didn't see any comments on 9/12 "add multiple queue support" but
I get the feeling that something(s) is missing. In testing I see
very little improvement in iops or throughput (well at least it
doesn't degrade things).

Patch 11/12 "uuid for lu name" indicates work is needed in other
areas. For example when the LU name is a UUID, I see no entries
for the that LU in /dev/disk/by-uuid (its partitions yes, but not
the whole LU). Is that a udev issue? Also 'lsscsi -u' needs work,
obviously I can sort that out. My other utilities (i.e. sg_inq,
sg_vpd and sdparm) have been updated but not formally released;
there is a sg3_utils-1.43 beta at:
    http://sg.danny.cz/sg/

Hannes Reinecke has set up a git mirror of my development sg3_utils
(subversion) repository. It is at:
    https://github.com/hreinecke/sg3_utils
and is almost up to date (it was synced yesterday).

Doug Gilbert

