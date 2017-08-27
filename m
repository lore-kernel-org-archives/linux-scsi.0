From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Sun, 27 Aug 2017 20:42:52 +0200
Message-ID: <ce5bad3e349648cf2d3444e42b2f641c@assyoma.it>
References: <20170826205848.BC21C4E0007@mta-1.openmailbox.og>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:51359 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdH0SnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2017 14:43:02 -0400
In-Reply-To: <20170826205848.BC21C4E0007@mta-1.openmailbox.og>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sonofagun@openmailbox.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Il 26-08-2017 22:58 sonofagun@openmailbox.org ha scritto:
> Hello guys, this is a very interesting thread but I will join it 
> tomorrow!
> 
> I have read a similar discussion for SSDs some time ago. That took
> place here [1]. Corruption of such devices can lead to complete data
> loss and not just corruption.

I just read the thread at https://marc.info/?t=149186660400002&r=1&w=2, 
it was very interesting. However, it seems to me that  it ended without 
a clear solution, right?

Anyway, the opacity of the FTL (flash translation layer) surely is a 
significant cause of concern/danger. Unexpected power losses can wreak 
havock on SSDs.

> Please install smartmontools and post its output here for each disk so
> that I can see if your disks are healthy. Also I must see their
> firmware version as there might be a firmware update available.

Fortunately, the issue is solved now: I tracked back it to a faulty SATA 
power cable. However, the SMART reports of both disk is very 
interesting:


GOOD DISK (sda):
[root@nas ~]# smartctl -A /dev/sda
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.10.0-514.el7.x86_64] 
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, 
www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   111   099   006    Pre-fail  Always 
       -       30483624
   3 Spin_Up_Time            0x0003   093   091   000    Pre-fail  Always 
       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always 
       -       46
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always 
       -       0
   7 Seek_Error_Rate         0x000f   077   060   030    Pre-fail  Always 
       -       55353954
   9 Power_On_Hours          0x0032   091   091   000    Old_age   Always 
       -       8535
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always 
       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always 
       -       44
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always 
       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   067   060   045    Old_age   Always 
       -       33 (Min/Max 30/40)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always 
       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always 
       -       24
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always 
       -       67
194 Temperature_Celsius     0x0022   033   040   000    Old_age   Always 
       -       33 (0 14 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       0

Note the low (expected) Start_Stop_Count (46)


BAD DISK (sdb):
[root@nas ~]# smartctl -A /dev/sdb
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.10.0-514.el7.x86_64] 
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, 
www.smartmontools.org

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   106   099   006    Pre-fail  Always 
       -       11030016
   3 Spin_Up_Time            0x0003   095   091   000    Pre-fail  Always 
       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always 
       -       661
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always 
       -       0
   7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail  Always 
       -       60912204
   9 Power_On_Hours          0x0032   091   091   000    Old_age   Always 
       -       8536
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always 
       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always 
       -       44
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always 
       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   067   061   045    Old_age   Always 
       -       33 (Min/Max 29/39)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always 
       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always 
       -       639
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always 
       -       672
194 Temperature_Celsius     0x0022   033   040   000    Old_age   Always 
       -       33 (0 14 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       0

Note the *much* higher Start_Stop_Count (661); however, the 
Power_Cycle_Count was the same (44).

So yes, while HDDs surely are more resilient than SSDs to unexpected 
power losses, a micro-powerloss which corrupt/invalidate the disk's 
cache content without giving the host a change to notice *will* cause 
data corruption, sometime on acked syncronized writes also (I had a 
filesystem journal corruption).

However, as stated in this thread, SATA does not really has a provision 
to detect failed command due to micro-powerlosses nor to detect and 
invalid/corrupted disk cache. So it seems the better "line of defese" is 
to monitor (via SMART) the start/stop or power cycles count.

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
