From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: Help - why mid-layer does not scan LUNs?
Date: Fri, 18 Jun 2004 14:29:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA20433932@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:5314 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264296AbUFRV3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2004 17:29:14 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>, linux-scsi@vger.kernel.org

Make sure you have CONFIG_SCSI_MULTI_LUN=y in you kernel's .config file.
If you don't the mid-layer will not scan past lun # 0 for any target.  
Without this the only other thing I know of is use proc interface to add
more luns.  

Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>owner@vger.kernel.org] On Behalf Of Lee Xing
>>Sent: Friday, June 18, 2004 4:10 PM
>>To: linux-scsi@vger.kernel.org
>>Subject: Help - why mid-layer does not scan LUNs?
>>
>>Hi,
>>
>>Can some one please tell me why mid-layer doesn't scan LUNs but just
Buses
>>and Targets in lk 2.4?
>>
>>The default max_channel, max_id and max_lun defined in mid-layer are
0, 8
>>and 8 respectively.  I use scsi_debug low-level driver to check which
>>B:T:L mid-layer scans, but find it only scans 0:0:0, 0:1:0, 0:2:0...
Why
>>it doesn't scan 0:0:1, 0:0:2...?
>>
>>I have taken out:
>>
>>	if ((target > driver_template.this_id) || (SCpnt->lun != 0))
>>		return schedule_resp(SCpnt, NULL, done, DID_NO_CONNECT
<< 16,
>>0);
>>
>>from scsi_debug_queuecommand(...) of scsi_debug driver, but mid-layer
>>still does not scan LUNs.
>>
>>I would appreciate it if some one could tell me what I missed.
>>
>>Thanks,
>>
>>
>>Lee
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
