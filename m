From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Wed, 29 Oct 2003 08:53:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067442833.1103.7.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310291004230.874-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:62212 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S261943AbTJ2Py6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:54:58 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310291004230.874-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Wed, 2003-10-29 at 08:09, Alan Stern wrote:
> On Tue, 28 Oct 2003, Patrick Mansfield wrote:
> 
> > On Tue, Oct 28, 2003 at 05:49:48PM -0500, Alan Stern wrote:
> > 
> > > Your device doesn't like the MODE-SENSE(10) for page 3F.  But instead of 
> > > reporting a normal error code, it tries to send an overlong packet (i.e., 
> > > longer than the host asked for).  Of course this is an error, and the SCSI 
> > > code retries several times, eventually giving up.  Oddly enough, the 
> > > device then returns an Invalid Command status for the _next_ command, 
> > > which is an innocuous TEST-UNIT-READY.  I don't understand that.
> > 
> > > Anyway, the SCSI layer recognizes that something is wrong.  But for some
> > > unknown reason it goes right back to the beginning of the probe sequence,
> > > starting with another TEST-UNIT-READY, READ-CAPACITY, and moving on.  
> > > Naturally enough, when it reaches the MODE-SENSE(10) again the same
> > > problem reoccurs.  Patrick, do you know why the sd initialization code is
> > > doing this?
> > 
> > It does not go back to the probe (scsi scan or sd_probe code), sd_open for
> > removable media can call sd_revalidate_disk. sd_revalidate_disk is also
> > called via sd_probe.
> 
> Okay, thanks for clearing that up.
> 
> > The partition check code in register_disk opens the block device once (can
> > anyone verify that?) calling sd_open. But it almost looks like we have
> > multiple sd_open calls - given the multiple TEST UNIT READY's READ
> > CAPACITY, and MODE SENSE calls.
> > 
> > I think the sdev->changed is getting set, causing the read command
> > (sd_init_command fails) to fail.
> > 
> > I'll look more tomorrow. If anyone figures out or knows the sdev->changed
> > code please post.
> > 
> > > Even the successful logfile had an odd feature.  The sd driver knew enough
> > > to skip both the page 3F and the page 8 MODE-SENSE(10) calls.  But then it
> > > went ahead and issued MODE-SENSE(6) for page 8!  Fortunately this worked
> > > (or rather, failed cleanly enough) for things to progress okay.  Patrick,
> > > can you explain that too?
> > 
> > The scsi_dev_flags overrides the host adapter setting, and we did not tell
> > it to skip page 8. Since it worked it does not matter, but we could have
> > used (given BLIST_MS_SKIP_PAGE_08 is 0x2000 and BLIST_MS_SKIP_PAGE_3F is
> > 0x4000):
> > 	
> > 	echo "model:vendor:0x6000" > /proc/scsi/device_info
> 
> I don't get it.  The log shows there was no MODE-SENSE(10) issued for page 
> 8, but the MODE-SENSE(6) was issued at exactly the corresponding place.  
> This indicates that the sdev->use_10_for_ms flag wasn't set.  Why not?  I 
> thought it was always set initially and cleared only if the 10-byte 
> command provokes an error.
> 

Alan, Patrick
this is what I was trying to say, the flag is on by default, see
scsiglue.c. Ok I used the word always, my wrong. I meant default and yes
I believe it can be overwritten but isn't in the current (test-9) case.
In other words sd.c sees that flag and skips to the end of
sd_read_cache_type

       if (sdkp->device->skip_ms_page_8)
                goto defaults;
                                                                                
        /* cautiously ask */
        res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
                                                                                

Ok first coffee, hope it's clearer now what I meant. But maybe I'm still
way of.
Ronald



> Alan Stern
> 
> 

