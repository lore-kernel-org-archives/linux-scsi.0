From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Wed, 6 Nov 2002 17:13:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106171345.A20152@eng2.beaverton.ibm.com>
References: <200211051220.EAA26599@adam.yggdrasil.com> <20021106005420.A27699@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021106005420.A27699@lst.de>; from hch@lst.de on Wed, Nov 06, 2002 at 12:54:20AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 12:54:20AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 05, 2002 at 04:20:15AM -0800, Adam J. Richter wrote:

> Okay, here's a version with minimal cleanups (different placements of
> the functions, use of list_for_each_entry, etc..) against
> scsi-for-linus-2.5.  Patch looks fine to me, but I had no chance to
> actually test the boot argument.

I tried without a boot argument, and I get host number slippage on
rmmod/insmod (there are 3 bugs in sysfs, and one in scsi that break
rmmod - I'll try and post a hack patch).

scsihosts is always NULL in the following, so we never reuse any host
numbers. This does not match the previous behaviour (AFAIR), not that
I personally have a beef with this but I assume some users will want
their host numbers to be the same on rmmod/insmod (or hotplug?) of ans
adapter.

> +static int scsi_alloc_host_num(const char *name)
> +{
> +	int hostnum = 0;
> +
> +	if (name && scsihosts && scsihosts[0] != '\0') {
> +		const int namelen = strlen(name);
> +		const char *start, *end;
> +
> +		for (start = scsihosts; start; start = end, hostnum++) {
> +			int hostlen;
> +
> +			end = strpbrk(start, ",:");
> +			hostlen = end ? (end - start) : strlen(start);
> +
> +			if (hostlen != namelen)
> +				continue;
> +			if (strncmp(name, start, hostlen))
> +				continue;
> +			if (scsi_find_host_by_num(hostnum))
> +				continue;
> +			return hostnum;
> +		}
> +	}
> +
> +	return scsi_host_next_hn++;
> +}

-- Patrick Mansfield
