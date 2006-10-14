From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] replace dm hw handlers with scsi handlers
Date: Sat, 14 Oct 2006 09:09:46 -0400
Message-ID: <4530E19A.8040002@cs.wisc.edu>
References: <1160684310.4163.4.camel@madmax>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1160684310.4163.4.camel@madmax>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@free.fr>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> - Bind per device instead of per target to allow for
> per LU failover.
> - Merge Ed's updated dm-emc code into scsi_emc_clariion.
> - Add basic code to hook into REQ_TYPE_LINUX_BLOCK cmd_type
> (must ask Jens if this is how he wanted it).
> - Do a partial conversion of dm-mpath.c (hooked dm-mpath.c
> in, but all the hw handler code can now be removed (will
> do this in a seperate patch to reduce noise)).
> - added device_id table to bind devices to modules by.
> 

I updated this patchset here

http://kernel.org/git/?p=linux/kernel/git/mnc/linux-2.6-iscsi.git;a=summary

in the multipath branch.

I added a rdac handler and hp storage works one that does START_STOP. I
also integrated it into the devinfo table (cannot update from proc or
module param just yet) and fixed some bugs and did some cleanup - still
need to better integrate the REQ cmt type checking.

Christophe V, I was wondering what is the vendor/module info for your
box? We have a MSA1000 VOLUME/COMPAQ here, but START_STOP does not work.
I mean if I send the command it always executes successfully, but the
device does not failover (READ/WRITEs fail). I tried just running
sg_start and this runs ok but READ/WRITE still fail, so I hacked up
scsi_debug to simulate my testing.

If you want to try it out, you just have to add a devinfo entry for your
box. I did this for the MSA I thought used it by adding the "hp_sw"
string to the end of an existing devinfo entry:

+       {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD, "hp_sw"},
+       {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD, "hp_sw"},


and you need to use a slightly different table format. I use this for a
setup with two paths (one to each target controller) with each path in a
different priority group.

0 16384 multipath 1 queue_if_no_path 1 1 2 1 round-robin 0 1 1 8:48 1000
round-robin 0 1 1 8:32 1000

0 16384 multipath 1 queue_if_no_path        <the bits here "1 1" is what
changed >         2 1 round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:32
1000

If you have a device that needs manual failover, you pass "1 1". If it
it does not require manual failover then just pass "0".  There is no
need to pass any hw handler type because the hw handler is no longer in
dm. Later when we do more advanced configuration we will have to write
to some sysfs interface at the scsi layer to configure values like the
tresspass or page2c type (clariion and rdac settings).
