From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Fri, 06 Mar 2015 22:25:56 -0800
Message-ID: <1425709556.15055.42.camel@haakon3.risingtidesystems.com>
References: <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
	 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
	 <54F1ADAF.90808@sandisk.com>
	 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
	 <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org>
	 <54F87F17.30207@sandisk.com> <54F8A2B0.70202@redhat.com>
	 <54F9565A.2080103@sandisk.com> <54F9FCEB.3080806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54F9FCEB.3080806@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-03-06 at 11:15 -0800, Andy Grover wrote:

<SNIP>

> This isn't a problem, because having a configuration for a device's WWNs 
> in configfs does not mean the device must be present. When the device 
> shows up then the target config will be used for it, and if the device 
> is removed the configuration no longer does anything, but still remains.
> 
> What's in configfs reflects only the config, which is why I'm wondering 
> if adding sysfs support might also be a good thing. sysfs would let LIO 
> create entries to better reflect actual running state, and be less 
> limited in reporting status on only "things that have config".
> 
> For example, LIO requires an ACL for all initiators but has a setting to 
> autogenerate these if per-ACL lun-mapping & auth is not desired. There's 
> no way for userspace to get a list of generated ACLs --

Thanks for the reminder.

Just posted a small series for allowing fabric drivers to expose this
using a new 'dynamic_session' TPG attribute, so that user-space can
optionally perform dynamic -> explicit se_node_acl conversion ...

> maybe userspace 
> wants to make it easy to convert generated ACLs to actual ACLs. LIO 
> can't create configfs nodes in-kernel and each configfs file is limited 
> to PAGE_SIZE so we can't just have a configfs entry that lists all of 
> them.

... which yes, like all sysfs + configfs attrs is currently limited to a
PAGE_SIZE of output.

However, given iSCSI IQNs are on average ~64 bytes (max 224 bytes), that
is still enough for listing 64 (or 18 worst case) sessions created by
dynamically generated se_node_acls .

For FC, this is 18 bytes per FC initiator WWPN string using physical
port addressing.

So for most folk's purposes on a per target endpoint basis, they won't
have enough active sessions to run out of buffer here.

>  That's what I was getting at above: configfs works great for 
> exactly what we're using it for, but there are other things sysfs does 
> better so we may want to use both.
> 

Not sure what you had in mind, but I did attempt using both in the early
days..  Eg: using /sys/block/$BDEV/ as sysfs symlink source for passing
struct block_device into /sys/kernel/config/target/core/$IBLOCK/$DEV/.

IIRC, Greg-KH's response back then was along the lines of 'thanks, but
please stop now and walk away slowly'.

--nab
