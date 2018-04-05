From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH 1/1] target:separate tx/rx cmd_puds
Date: Thu, 5 Apr 2018 13:12:12 +0200
Message-ID: <20180405131212.3f26339d@suse.de>
References: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

The commit summary has a typo (cmd_puds). That said, this change
isn't iSCSI specific, so using "pdu" here doesn't make much sense IMO.

On Wed, 21 Mar 2018 17:52:43 +0800, Zhang Zhuoyu wrote:

> Separate tx/rx cmd_pdus in order to distinguish LUN read/write IOPS.
> 
> Signed-off-by: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_stat.c      | 26 ++++++++++++++++++++++----
>  drivers/target/target_core_transport.c | 11 ++++++++++-
>  include/target/target_core_base.h      |  3 ++-
>  3 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index f0db91e..9099494 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -706,7 +722,8 @@ static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
>  CONFIGFS_ATTR_RO(target_stat_tgt_port_, indx);
>  CONFIGFS_ATTR_RO(target_stat_tgt_port_, name);
>  CONFIGFS_ATTR_RO(target_stat_tgt_port_, port_index);
> -CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
> +CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
> +CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds);

I don't think the in_cmds metric should be deleted here. It could be
calculated on the fly via tx_cmds + rx_cmds + nodata_cmds.

Cheers, David
