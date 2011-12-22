From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM TOPIC] linux servers as a storage server - what's
 missing?
Date: Thu, 22 Dec 2011 13:44:16 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>
References: <4EF2026F.2090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxipps301.us.dell.com ([143.166.148.223]:18069 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1LVIOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2011 03:14:33 -0500
In-Reply-To: <4EF2026F.2090506@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Ric Wheeler
> Sent: Wednesday, December 21, 2011 11:00 AM
> To: linux-fsdevel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: [LSF/MM TOPIC] linux servers as a storage server - what's
> missing?
> 
> 
> One common thing that I see a lot of these days is an increasing number
> of
> platforms that are built on our stack as storage servers. Ranging from
> the
> common linux based storage/NAS devices up to various distributed
> systems.
> Almost all of them use our common stack - software RAID, LVM, XFS/ext4
> and samba.
> 
> At last year's SNIA developers conference, it was clear that Microsoft
> is
> putting a lot of effort into enhancing windows 8 server as a storage
> server with
> both support for a pNFS server and of course SMB. I think that linux
> (+samba) is
> ahead of the windows based storage appliances today, but they are
> putting
> together a very aggressive list of features.
> 
> I think that it would be useful and interesting to take a slot at this
> year's
> LSF to see how we are doing in this space. How large do we need to
> scale for an
> appliance?  What kind of work is needed (support for the copy offload
> system
> call? better support for out of band notifications like those used in
> "thinly
> provisioned" SCSI devices? management API's? Ease of use CLI work?
> SMB2.2 support?).
> 
> The goal would be to see what technical gaps we have that need more
> active
> development in, not just a wish list :)
> 
> Ric

Working for a company that works with different OS vendors I get involved in such discussions on what linux offers and what it doesn't and where the gaps are both at the code level and the customer usage patterns..

A few things that stand out..

- Management models.. Performance models.

I tend to think that we(linux folks) get into performance paradigm more frequently in the kernel and leave the management paradigms to the big vendors to play around leaving a lot of inconsistency in storage management by sysadmins.

I think the analogy could be equated to a traffic scenario with rules vs a traffic scenario without rules.
The traffic scenario without rules generally leaves a skilled expert driver navigating the traffic swiftly and reaching the destination much faster than the others but at the same time leaving the non-driving passenger with a bad feeling in the stomach.
The customer is the analogy of the non-driving passenger in the case of linux.

For eg: If someone had to write a decent use case that lets you use a clustered framework with nfs/pnfs with iSCSI storage backend supporting Copy offload while managing backup all you would end up is having a set of management windows in setting up this whole framework unless you are a vendor willing to take some extra brownie points from the customer in  writing this whole thing up and packaging it into a framework. And if there are features not implemented in a particular filesystem/kernel subsystem like the copy offload it just needs a lot of synchronization which means the feature generally takes a long time to evolve.

The kernel feature is usually implemented with the performance in mind but the management of the feature is usually left to the user.

In this case a vendor includes OS distributions and stake holder storage companies..

If I flip this over to what other OSes offer..

1) A consistent clustered filesystem that supports performance oriented features like copy offload and optimization features like thin provisioning
2) A management api for things like thin provisioning with well documented hooks to write a vendor specific plugin
3) GUI/CLI support
4) Backup management/API with hooks for vendor plugins

Usually all of this is within a common framework or single management window... providing a consistent view.

Simple asks -
1) Provide a consistent storage and fs management library that discourages folks to write their own usespace storage library. Include things like fs formatting(fs profiles), transport configuration(eg: iscsiadm as a library), thin provisioning watermarks, cluster management, apis for cgroups etc. The library should provide a clean set of rules/interfaces to build management apps for.
Think Android market place providing a well defined framework for app writers. Let the distributions/Storage companies write their own cool apps with this framework..

2) View implementations like copy offload, thin provisioning, snapshots, watermarks in the kernel in conjunction with this storage library. So a usecase has to be discussed to be included in this library before working in the kernel

3) And this may sound controversial but inspite of being a long time linux fan, user and observer I would say provide hooks for folks to write clean pluggins that lets them protect their proprietary work by allowing them to bundle binary blobs. 
Usually folks want to keep proprietary plugins in this area because -
    a) No other storage vendor provides an open source pluggin. So if you are a storage vendor listening this might be your cue to start the avalanche
    b) They are into IP protection agreement with another OS vendor
    c) A startup protecting its IP
The benefits of open sourcing are usually realized when maintaining code.. :-) not when pitching it against simpler management frameworks offered by other OS vendors who are able to offer the feature as vendors mutually want to keep it proprietary.
(The last one being my personal opinion and not as the employee of an increasingly storage company)

/me fully expects brickbats but then as they say from where I come from - A fool can always try his luck a few times and get wise in the process.. :-)


