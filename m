From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Configuring the device_list in scsi_scan.c
Date: Thu, 30 May 2002 15:54:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530155453.A25474@eng2.beaverton.ibm.com>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C5EA4@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <08628CA53C6CBA4ABAFB9E808A5214CB0C5EA4@mercury.infiniconsys.com>; from mheinz@infiniconsys.com on Thu, May 30, 2002 at 05:18:29PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

Did you add a BLIST_FORCELUN or BLIST_SPARSELUN entry?

If BLIST_FORCELUN, you should instead boot or load the adapter module
with max_scsi_luns=value

BLIST_FORCELUN is really only need if you have a device that is broken
scanning past LUN 0 (BLIST_NOLUN) but is not in the device_list.

BLIST_SPARSELUN really needs REPORT LUN scanning, I think someone at
EMC has backported it to 2.4.x.

If you had to modify /proc to see the LUN, booting of a non-0 LUN device
would not be easy, plus you would have to scan again.

I'd like to see a hotplug like interface for the device_list settings
(at least in 2.5.x).

-- Patrick Mansfield

On Thu, May 30, 2002 at 05:18:29PM -0400, Heinz, Michael wrote:
> We just ran into an issue where the RAID array we purchased didn't quite
> work with Linux, because only the first LUN was visible (Red Hat
> 2.4.7-10).
> 
> I patched the kernel by adding the array to the device_list in
> scsi_scan.c, but that seems obnoxious. It occurs to me that it would be
> straight forward to modify scsi.c and scsi_scan.c so that you could
> write to /proc/scsi/scsi and add new entries to the device_list; and a
> module parameter that would let you add a single new entry to the
> device_list right at load time.
> 
> Before I start fighting with my boss over whether I have time to write
> patches for the linux kernel - does this fix make sense?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
