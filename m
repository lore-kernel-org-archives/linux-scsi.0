From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/8] target_core_alua: Referrals configfs integration
Date: Wed, 18 Dec 2013 22:25:02 -0800
Message-ID: <1387434302.5567.35.camel@haakon3.risingtidesystems.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
	 <1387268330-121064-9-git-send-email-hare@suse.de>
	 <1387313347.20247.316.camel@haakon3.risingtidesystems.com>
	 <52B15999.9090207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51347 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LSGYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 01:24:05 -0500
In-Reply-To: <52B15999.9090207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-12-18 at 09:15 +0100, Hannes Reinecke wrote:
> On 12/17/2013 09:49 PM, Nicholas A. Bellinger wrote:
> > On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
> >> Referrals need an LBA map, which needs to be kept
> >> consistent across all target port groups. So
> >> instead of tying the map to the target port groups
> >> I've implemented a single attribute containing the
> >> entire map.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/target/target_core_alua.c      | 101 +++++++++++++++++++
> >>  drivers/target/target_core_alua.h      |   8 ++
> >>  drivers/target/target_core_configfs.c  | 171 +++++++++++++++++++++++++++++++++
> >>  drivers/target/target_core_device.c    |   1 +
> >>  drivers/target/target_core_transport.c |  28 +++++-
> >>  5 files changed, 308 insertions(+), 1 deletion(-)
> >>
> > 
> > Applied, with one comment below..
> > 
> > <SNIP>
> > 
> >> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> >> index e74ef8c..1dbc1bc 100644
> >> --- a/drivers/target/target_core_configfs.c
> >> +++ b/drivers/target/target_core_configfs.c
> >> @@ -1741,6 +1741,176 @@ static struct target_core_configfs_attribute target_core_attr_dev_alua_lu_gp = {
> >>  	.store	= target_core_store_alua_lu_gp,
> >>  };
> >>  
> >> +static ssize_t target_core_show_dev_lba_map(void *p, char *page)
> >> +{
> >> +	struct se_device *dev = p;
> >> +	struct t10_alua_lba_map *map;
> >> +	struct t10_alua_lba_map_member *mem;
> >> +	char *b = page;
> >> +	int bl = 0;
> >> +	char state;
> >> +
> >> +	spin_lock(&dev->t10_alua.lba_map_lock);
> >> +	if (!list_empty(&dev->t10_alua.lba_map_list))
> >> +	    bl += sprintf(b + bl, "%u %u\n",
> >> +			  dev->t10_alua.lba_map_segment_size,
> >> +			  dev->t10_alua.lba_map_segment_multiplier);
> >> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list, lba_map_list) {
> >> +		bl += sprintf(b + bl, "%llu %llu",
> >> +			      map->lba_map_first_lba, map->lba_map_last_lba);
> >> +		list_for_each_entry(mem, &map->lba_map_mem_list,
> >> +				    lba_map_mem_list) {
> >> +			switch (mem->lba_map_mem_alua_state) {
> >> +			case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
> >> +				state = 'O';
> >> +				break;
> >> +			case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
> >> +				state = 'A';
> >> +				break;
> >> +			case ALUA_ACCESS_STATE_STANDBY:
> >> +				state = 'S';
> >> +				break;
> >> +			case ALUA_ACCESS_STATE_UNAVAILABLE:
> >> +				state = 'U';
> >> +				break;
> >> +			default:
> >> +				state = '.';
> >> +				break;
> >> +			}
> >> +			bl += sprintf(b + bl, " %d:%c",
> >> +				      mem->lba_map_mem_alua_pg_id, state);
> >> +		}
> >> +		bl += sprintf(b + bl, "\n");
> >> +	}
> >> +	spin_unlock(&dev->t10_alua.lba_map_lock);
> > 
> > The above loop can possibly overflow the passed *page..
> > 
> No. This is the reverse operation to the constructor in
> target_core_store_dev_lba_map().
> 
> Which (per definition) can only handle maps up to one page in size.
> 
> And hence the resulting (formatted) map as constructed by
> target_core_show_dev_lba_map() will also fit on one page.
> 

Sure, but AFAICT nothing prevents target_core_store_dev_lba_map() ->
core_alua_set_lba_map() from being called multiple times, and thus
potentially increasing target_core_show_dev_lba_map() output to larger
than PAGE_SIZE..

--nab

