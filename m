From: Mike Christie <mchristi@redhat.com>
Subject: Re: iscsi: make mutex for target scanning and unbinding per-session
Date: Thu, 10 Nov 2016 23:01:33 -0600
Message-ID: <582550AD.9010007@redhat.com>
References: <1478542920-24460-1-git-send-email-cleech@redhat.com>
 <58250144.2050009@redhat.com>
 <20161111011303.mod2s5wyymge6byx@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbcKKFBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 00:01:35 -0500
In-Reply-To: <20161111011303.mod2s5wyymge6byx@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, lduncan@suse.com

On 11/10/2016 07:13 PM, Chris Leech wrote:
> On Thu, Nov 10, 2016 at 05:22:44PM -0600, Mike Christie wrote:
>> > On 11/07/2016 12:22 PM, Chris Leech wrote:
>>> > > Currently the iSCSI transport class synchronises target scanning and
>>> > > unbinding with a host level mutex.  For multi-session hosts (offloading
>>> > > iSCSI HBAs) connecting to storage arrays that may implement one
>>> > > target-per-lun, this can result in the target scan work for hundreds of
>>> > > sessions being serialized behind a single mutex.  With slow enough
>> > 
>> > Does this patch alone help or is there a scsi piece too?
>  
> I had this tested when working a hung task timeout issue at boot, and
> was told that it fixed the issue.  The exact situation may be more
> complex, I think it was only 128 sessions which is surprising that it
> would hit a 2 minute timeout.  But every backtrace was at this mutex.
> 

I think you are also hitting a issue where the normal scan time is
higher than usual and that might be a userspace bug. I am not sure how
the mutex patch helps, but I have not thought about it.

I think iscsid will scan the entire host during login. We only want
iscsi_sysfs_scan_host to scan the specific target for the session we
just logged into.

In the kernel we are setting SCSI_SCAN_RESCAN for the scan and userspace
did echo - - - > ..../scan for the entire host, so iscsi_user_scan is
going to rescan every target that is setup. So once you get to 127
sessions/targets it could be a loonngg scan of all 127 of them, and
target 128 is going to have to wait a loooonnggg time for that mutex and
then also execute a long scan.

If you have userspace do the single target scan, it should execute
faster. I know that does not solve the serialization problem. You will
still have lots of targets waiting to be scanned.

