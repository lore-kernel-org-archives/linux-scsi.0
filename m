From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [LSF/MM TOPIC] SMR: Disrupting recording technology meriting a
 new class of storage device
Date: Fri, 7 Feb 2014 11:00:15 -0200
Message-ID: <20140207130014.GA5078@localhost.localdomain>
References: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaBGNcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 08:32:51 -0500
Content-Disposition: inline
In-Reply-To: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Albert Chen <Albert.Chen@wdc.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, James Borden <James.Borden@wdc.com>, Jim Malina <Jim.Malina@wdc.com>, Curtis Stevens <curtis.stevens@wdc.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

On Sat, Feb 01, 2014 at 02:24:33AM +0000, Albert Chen wrote:
> [LSF/MM TOPIC] SMR: Disrupting recording technology meriting a new class of storage device
> 
> Shingle Magnetic Recording is a disruptive technology that delivers the next areal density gain for the HDD industry by partially overlapping tracks. Shingling requires physical writes to be sequential, and opens the question of how to address this behavior at a system level. Two general approaches contemplated are to either to do the block management in the device or in the host storage stack/file system through Zone Block Commands (ZBC).
> 
> The use of ZBC to handle SMR block management yields several benefits such as:
> - Predictable performance and latency
> - Faster development time
> - Access to application and system level semantic information
> - Scalability / Fewer Drive Resources
> - Higher reliability
> 
> Essential to a host managed approach (ZBC) is the openness of Linux and its community is a good place for WD to validate and seek feedback for our thinking - where in the Linux system stack is the best place to add ZBC handling? at the Device Mapper layer? or somewhere else in the storage stack? New ideas and comments are appreciated.

If you add ZBC handling into the device-mapper layer, aren't you supposing that
all SMR devices will be managed by device-mapper? This doesn't look right IMHO.
These devices should be able to be managed via DM or either directly via de
storage layer. And any other layers making use of these devices (like DM for
example) should be able to communicate with them and send ZBC commands as
needed.

> 
> For more information about ZBC, please refer to Ted's <tytso@MIT.EDU> email to linux-fsdevel@vger.kernel.org with the subject " [RFC] Draft Linux kernel interfaces for ZBC drives".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
