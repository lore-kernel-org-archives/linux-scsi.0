From: Artem Bokhan <aptem@ngs.ru>
Subject: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 16:20:56 +0600
Message-ID: <4D5A5388.3010208@ngs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello!

I'm trying to get/set sctserc (SMART Command Transport Error Recovery  Control) 
data from sata disk attached to lsi megaraid controller with smartmontools, but 
this function does not work.

I want to figure out: is this driver or firmware issue? May someone to help to 
fix this?

The issue can be described as follows:

The ATA PASS-THROUGH(16) implementation in the SAT layer of the megaraid driver 
or firmware does not return the ATA output registers if requested. This violates 
SAT standard (http://www.t10.org/drafts.htm#SAT).

Expected: If CK_COND (bit 5 of CDB[2]) is set, ATA PASS-THROUGH(16) (CDB[0] = 
0x85) shall return a CHECK CONDITION even if the ATA command completed 
successfully, and return the ATA output registers in the sense data using ATA 
return descriptor format (descriptor code 0x09).

Observed: If CK_COND is set and the ATA command completed successfully, ATA 
PASS-THROUGH(16) does not return a CHECK CONDITION or the sense data does not 
contain an ATA return descriptor.

See also the smartmontools SAT implementation 
(http://sourceforge.net/apps/trac/smartmontools/browser/trunk/smartmontools/scsiata.cpp?rev=3258#L146) 
for further info.
