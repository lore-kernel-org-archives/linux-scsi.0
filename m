From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid disk failure, options?
Date: Mon, 02 Nov 2009 10:00:27 -0500
Message-ID: <4AEEF40B.4060103@tmr.com>
References: <200911011216.32196.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:34161 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZKBPAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 10:00:25 -0500
In-Reply-To: <200911011216.32196.tfjellstrom@shaw.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Thomas Fjellstrom wrote:
> My main raid array just had a disk failure. I tried to hot remove the 
> device, and use the scsi bus rescan sysfs entries, but it seems to fail on 
> IDENTIFY.
>
> Can I assume my disk is dead?
>
>
> [5015721.851044] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0                                                                                                                                                                  
> [5015721.851089] ata3.00: irq_stat 0x40000001                                                                                                                                                                                               
> [5015721.851124] ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0                                                                                                                                                                     
> [5015721.851125]          res 71/04:03:80:01:32/00:00:00:00:00/e0 Emask 0x1 
> (device error)                                                                                                                                                  
> [5015721.851193] ata3.00: status: { DRDY DF ERR }                                                                                                                                                                                           
> [5015721.851225] ata3.00: error: { ABRT }                                                                                                                                                                                                   
> [5015726.848684] ata3.00: qc timeout (cmd 0xec)                                                                                                                                                                                             
> [5015726.848729] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)                                                                                                                                                                      
> [5015726.848763] ata3.00: revalidation failed (errno=-5)                                                                                                                                                                                    
> [5015726.848798] ata3: hard resetting link                                                                                                                                                                                                  
> [5015734.501527] ata3: softreset failed (device not ready)                                                                                                                                                                                  
> [5015734.501565] ata3: failed due to HW bug, retry pmp=0                                                                                                                                                                                    
> [5015734.665530] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                                                                                                     
> [5015734.707085] ata3.00: both IDENTIFYs aborted, assuming NODEV                                                                                                                                                                            
> [5015734.707089] ata3.00: revalidation failed (errno=-2)                                                                                                                                                                                    
> [5015739.664923] ata3: hard resetting link                                                                                                                                                                                                  
> [5015740.148277] ata3: softreset failed (device not ready)                                                                                                                                                                                  
> [5015740.148314] ata3: failed due to HW bug, retry pmp=0                                                                                                                                                                                    
> [5015740.313532] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [5015740.337129] ata3.00: both IDENTIFYs aborted, assuming NODEV
> [5015740.337132] ata3.00: revalidation failed (errno=-2)
> [5015740.337167] ata3.00: disabled
> [5015740.337231] ata3: EH complete
> [5015740.337275] sd 2:0:0:0: [sdc] Unhandled error code
> [5015740.337308] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
> [5015740.337372] end_request: I/O error, dev sdc, sector 1250258495
> [5015740.337410] end_request: I/O error, dev sdc, sector 1250258495
> [5015740.337445] md: super_written gets error=-5, uptodate=0
> [5015740.337479] raid5: Disk failure on sdc1, disabling device.
> [5015740.337480] raid5: Operation continuing on 3 devices.
> [5015740.337569] sd 2:0:0:0: [sdc] Unhandled error code
> [5015740.337601] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
> [5015740.337665] end_request: I/O error, dev sdc, sector 480014231
> [5015740.337710] sd 2:0:0:0: [sdc] Unhandled error code
> [5015740.337742] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
> [5015740.337806] end_request: I/O error, dev sdc, sector 1186573399
> [5015740.337840] sd 2:0:0:0: [sdc] Unhandled error code
> [5015740.337872] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
> [5015740.337936] end_request: I/O error, dev sdc, sector 404014999
> [5015740.371191] RAID5 conf printout:
> [5015740.371226]  --- rd:4 wd:3
> [5015740.371258]  disk 0, o:0, dev:sdc1
> [5015740.371290]  disk 1, o:1, dev:sda1
> [5015740.371322]  disk 2, o:1, dev:sdb1
> [5015740.371353]  disk 3, o:1, dev:sdd1
> [5015740.393516] RAID5 conf printout:
> [5015740.393551]  --- rd:4 wd:3
> [5015740.393583]  disk 1, o:1, dev:sda1
> [5015740.393615]  disk 2, o:1, dev:sdb1
> [5015740.393647]  disk 3, o:1, dev:sdd1
>
> ran: echo x > /sys/bus/scsi/devices/2\:0\:0\:0/delete
>
> [5016224.932073] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
> [5016224.932150] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
> [5016224.932216] sd 2:0:0:0: [sdc] Stopping disk
> [5016224.933192] sd 2:0:0:0: [sdc] START_STOP FAILED
> [5016224.933227] sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET 
> driverbyte=DRIVER_OK,SUGGEST_OK
>
> ran: echo "0 0 0" > /sys/class/scsi_host/host2/scan
>
> [5016463.173706] ata3: hard resetting link
> [5016463.657520] ata3: softreset failed (device not ready)
> [5016463.657557] ata3: failed due to HW bug, retry pmp=0
> [5016463.821535] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [5016463.842475] ata3.00: both IDENTIFYs aborted, assuming NODEV
> [5016463.842492] ata3: EH complete
>
> To be honest, I've been expecting this, I just had no idea which drive was 
> going to fail. For the past 6-12 months I've been hearing this rather loud 
> clicking noise coming from that machine, but I could never pin it down, it 
> only happened a couple times a day (and it wasn't heads parking).
>
>   
For future use, that's when you 'fail' the drive out of the array and 
listen to see if the noise goes away. Crude but effective. At this point 
I would expect the array to remain working, and rebuild properly after 
you replace your drive. But if you lose another your data is gone, so 
thinking about the possible solutions for long is not advisable.

> I'm tempted to try and reboot the machine, to see if the disk comes back. 
> But I'm worried the array might not come back (for whatever reason).
>   

See above, if another drive fails it definitely won't come back.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

