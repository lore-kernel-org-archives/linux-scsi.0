From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Need some pointers to debug a target hang
Date: Sat, 29 Oct 2016 15:53:25 -0700
Message-ID: <1477781605.22703.62.camel@haakon3.risingtidesystems.com>
References: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
         <1476770275.8490.10.camel@haakon3.risingtidesystems.com>
         <20161018070134.zhyk4ljaxzmvwfs2@linux-x5ow.site>
         <20161018173522.trhoqrcoeof4mn4w@linux-x5ow.site>
         <1476858567.8490.101.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476858567.8490.101.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Zhu Lingshan <lszhu@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hi Johannes & Zhu,

On Tue, 2016-10-18 at 23:29 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2016-10-18 at 19:35 +0200, Johannes Thumshirn wrote:
> > On Tue, Oct 18, 2016 at 09:01:34AM +0200, Johannes Thumshirn wrote:
> > 
> > [...]
> > 
> > > > 
> > > > This is likely the missing SCF_ACK_KREF assignment in >= v4.1.y:
> > > > 
> > > > http://www.spinics.net/lists/target-devel/msg13530.html
> > 
> > Sorry to disappoint you but it didn't fix my issue. Is there any debug data I
> > can give you, or do you have an advice where I could start looking?
> > 
> > I have to admit I only tested the patch on our downstream kernel and not the
> > upstream kernel, I'll repeat the tests on 4.8 final tomorrow.
> > 
> 
> Is it possible to generate vmcore to have a look in crash + gdb..?
> 
> 

Just curious if you've been able to verify the above patch for
v4.8.y iscsi-target ports on your specific config(s)..?

To confirm, using v4.1.y + patch I've not run into any further
se_cmd->cmd_kref leaks and/or hung tasks with iscsi-target ports due to
high backend device I/O latency, resulting in host timeouts + ABORT_TASK
+ session reinstatement to occur while waiting for outstanding se_cmd
backend I/O to complete.
