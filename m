From: Lincoln Dale <ltd@cisco.com>
Subject: Re: Fibre channel FC-4 features ?
Date: Sat, 14 Feb 2004 09:47:04 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040214093521.048bec08@171.71.163.14>
References: <BAY7-F6Xn5olXcJPDNL00009b9f@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:49063 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S267276AbUBMWrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:47:10 -0500
In-Reply-To: <BAY7-F6Xn5olXcJPDNL00009b9f@hotmail.com>
List-Id: linux-scsi@vger.kernel.org
To: invictus rm <invictus_rm@hotmail.com>
Cc: linux-scsi@vger.kernel.org

At 10:35 PM 13/02/2004, invictus rm wrote:
>Hi,
>  Presently i am looking into a way to find the list of FC initiator and 
> FC targets when i login to the
>  Fibre Chanel switch.
>
>  I want to maintain seperate list for INITIATORS and TARGETS attached to 
> the switch . The
>  switch at present is not supporting the FC-4 Features request , so i 
> cant use it to get the list of
>  initiator and the target.
>
>  How do i get the information when i login to the switch ?

devices typically register their FC-4 capabilities (e.g. scsi-fcp, fc-sb-3) 
with the nameserver after FLOGI.
if they don't explicitly provide information about themselves, you can try 
PLOGIing into them to see if they are an initiator or target.

many 'newer' devices also register symbolic-node-name information about 
themselves in the nameserver:
for example, we register iSCSI initiators with the IQN embedded in the 
nameserver also:
         VSAN:200   FCID:0x0b0202
         port-wwn (vendor)     :01:01:01:01:01:0d:00:11
         node-wwn              :01:01:01:01:01:0d:00:10
         class                 :2,3
         node-ip-addr          :10.67.16.91
         fc4-types:fc4_features:scsi-fcp:init iscsi-gw
         symbolic-node-name 
:iqn.1987-05.com.cisco:02.68248774bfe8.mel-stglab-host31
         port-type             :N
         fabric-port-wwn       :21:81:00:05:30:00:1d:1e

newer QLogic drivers do this also:
         VSAN:1 FCID:0xea0100
         port-wwn (vendor) :21:00:00:e0:8b:08:96:22 (Qlogic)
         node-wwn :20:00:00:e0:8b:08:96:22
         class :3
         fc4-types:fc4_features:scsi-fcp:init
         symbolic-node-name :QLA23xx FW:v3.01.19 DVR:v8.2.2.25 (W2K VI)
         port-type :N
         fabric-port-wwn :20:41:00:05:30:00:94:9e

the exact method you use from 'linux' to get this information is highly 
dependent on the HBA you're using --
unfortunately, this information isn't yet available in a "standardized" format.

there is perhaps hope that with Linux 2.7 the nameserver information can 
perhaps be populated into sysfs.
my hope is that the same holds true for FC-SP -- and that we don't end up 
with HBA-specific implementations.


cheers,

lincoln.
PS. why not post under your Aarohi email address?

