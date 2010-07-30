From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 15:07:25 +0200
Message-ID: <4C52CE8D.4020209@kernel.org>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab0G3NH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 09:07:56 -0400
In-Reply-To: <4C52CBFF.6090406@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 07/30/2010 02:56 PM, Vladislav Bolkhovitin wrote:
> 1. 1st journal write command (SIMPLE)
> 
> 2. 2d  journal write command (SIMPLE)
> 
> 3. 3d  journal write command (SIMPLE)
> 
> 4. SYNCHRONIZE_CACHE for blocks written by those 3 commands (ORDERED)
> 
> 5. Necessary amount of meta-data update commands (all SIMPLE)
> 
> 6. SYNCHRONIZE_CACHE for blocks written in 5 (ORDERED)
> 
> 7. Command marking the transaction committed in the journal (ORDERED)
> 
> That's all. No queue draining anywhere. Plus, sending commands
> without internal order requirements as SIMPLE would allow the drive
> to better schedule execution of them among internal storage (actual
> disks).

Are SIMPLE commands ordered against ORDERED commands?  Aren't ORDERED
ordered among themselves only?

-- 
tejun
