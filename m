From: "Zhang Zhuoyu" <zhangzhuoyu@cmss.chinamobile.com>
Subject: RE: [PATCH 1/1] target:separate tx/rx cmd_puds
Date: Sun, 8 Apr 2018 11:57:18 +0800
Message-ID: <000001d3ceed$b0d9c870$128d5950$@cmss.chinamobile.com>
References: <1521625963-657195-1-git-send-email-zhangzhuoyu@cmss.chinamobile.com>       <20180405131212.3f26339d@suse.de> <20180406140934.2dfafd45@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180406140934.2dfafd45@suse.de>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'David Disseldorp' <ddiss@suse.de>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: David Disseldorp [mailto:ddiss@suse.de]
> Sent: Friday, April 6, 2018 8:10 PM
> To: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
> Cc: nab@linux-iscsi.org; linux-scsi@vger.kernel.org; target-
> devel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] target:separate tx/rx cmd_puds
> 
> On Thu, 5 Apr 2018 13:12:12 +0200, David Disseldorp wrote:
> 
> > > -CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
> > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, tx_cmds);
> > > +CONFIGFS_ATTR_RO(target_stat_tgt_port_, rx_cmds);
> >
> > I don't think the in_cmds metric should be deleted here. It could be
> > calculated on the fly via tx_cmds + rx_cmds + nodata_cmds.
> 
> @Zhang Zhuoyu: How about something like the following?
> https://git.samba.org/?p=ddiss/linux.git;a=commitdiff;h=73723ccf433424721
> 830797d70cfb88d4596e0fc
> 

Mmm... This patch is much better. 
Looks good to me.

Zhuoyu

> ...this keeps the in_cmds metric, and renames tx/rx_cmds read/write_cmds
> respectively. read/write_cmds is still a bit ambiguous, as it refers to
the
> command data direction rather than SCSI READ/WRITE CDBs, but IMO it's
> clearer, and more consistent with the read/write_mbytes metrics.
> 
> Cheers, David
