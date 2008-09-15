From: Arne Redlich <agr@powerkom-dd.de>
Subject: Re: [PATCH] Allow more than 255 LUNs to
	be	reported.
Date: Mon, 15 Sep 2008 20:17:19 +0200
Message-ID: <1221502639.7703.112.camel@blackadder>
References: <20080912020830.GA14037@andromeda.dapyr.net>
	<1221197906.28571.42.camel@blackadder>
	<20080912134733.GB20527@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080912134733.GB20527@andromeda.dapyr.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: iscsitarget-devel@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

CC'ing linux-scsi.

Am Freitag, den 12.09.2008, 09:47 -0400 schrieb Konrad Rzeszutek: 
> On Fri, Sep 12, 2008 at 07:38:26AM +0200, Arne Redlich wrote:
> > Am Donnerstag, den 11.09.2008, 22:08 -0400 schrieb Konrad Rzeszutek:
> > > Allow more than 255 LUNs to be reported. The logic would
> > > make LUNs above 255 start at the 16k number.
> > > 
> > >  target_disk.c |    3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > Signed-off-by: Konrad Rzeszutek <ketuzsezr@darnok.org>
> > > 
> > > Index: kernel/target_disk.c
> > > ===================================================================
> > > --- kernel/target_disk.c	(revision 171)
> > > +++ kernel/target_disk.c	(working copy)
> > > @@ -279,8 +279,7 @@
> > >  		if (lun->l_state != IDEV_RUNNING)
> > >  			continue;
> > >  
> > > -		*data++ = cpu_to_be32((0x3ff & lun->lun) << 16 |
> > > -				      ((lun->lun > 0xff) ? (0x1 << 30) : 0));
> > > +		*data++ = cpu_to_be32((0x3ff & lun->lun) << 16);
> > 
> > Thanks, but I'm afraid this patch isn't correct.
> > 
> > Did you actually see this behaviour or did you stumble across it while
> 
> > iscsiadm -m discovery -t st -p 192.168.100.1
> 192.168.100.1:3260,1 iqn.2009.com.test:konrad
> 
> 09:43:15 # 7 :/etc/iscsi/ 
> > iscsiadm -m node -L all
> Logging in to [iface: default, target: iqn.2009.com.test:konrad, portal:
> 192.168.100.1,3260]
> Login to [iface: default, target: iqn.2009.com.test:konrad, portal:
> 192.168.100.1,3260]: successful
> 
> 09:43:20 # 8 :/etc/iscsi/ 
> > lsscsi
> [1:0:0:0]    disk    MAXTOR   ATLAS10K5_73SCA  JNZH  /dev/sda
> [1:0:6:0]    process ESG-SHV  SCA HSBP M35     1.06  -       
> [4:0:6:0]    process ESG-SHV  SCA HSBP M35     1.06  -       
> [4:0:10:0]   disk    MAXTOR   ATLAS10K5_73SCA  JNZH  /dev/sdb
> [8:0:0:0]    disk    IET      VIRTUAL-DISK     0     /dev/sdc
> [8:0:0:255]  disk    IET      VIRTUAL-DISK     0     /dev/sdd
> 
> 09:43:22 # 9 :/etc/iscsi/ 
> > /root/sg_luns /dev/sdc
> Lun list length = 48 which imples 6 lun entries
> Report luns [select_report=0]:
>     0000000000000000
>     00ff000000000000
>     4100000000000000
>     4200000000000000
>     4201000000000000
>     4300000000000000

Yes, this is absolutely ok - the highest two bits indicate the address
method.

Looking at the kernel's scsi_scan.c, scsilun_to_int()'s documentation
mentions this as well, but the code doesn't take any measures to handle
it. Syncing the code with the comment would be trivial, but then it
still would break on the inverse operation or extended logical unit
addressing formats. So I guess the issue needs to be fixed differently -
in particular the conversion to unsigned int when using extended
addressing formats with more than 4 bytes.

Is this already on someone's TODO list?

Cheers,
Arne

> 09:43:34 # 10 :/etc/iscsi/ 
> > dmesg | tail
> sdd: Write Protect is off
> sdd: Mode Sense: 77 00 00 08
> SCSI device sdd: drive cache: write through
>  sdd: unknown partition table
> sd 8:0:0:255: Attached scsi disk sdd
> sd 8:0:0:255: Attached scsi generic sg4 type 0
> scsi: host 8 channel 0 id 0 lun16640 has a LUN larger than allowed by
> the host adapter
> scsi: host 8 channel 0 id 0 lun16896 has a LUN larger than allowed by
> the host adapter
> scsi: host 8 channel 0 id 0 lun16897 has a LUN larger than allowed by
> the host adapter
> scsi: host 8 channel 0 id 0 lun17152 has a LUN larger than allowed by
> the host adapter
> 
> And on the 192.168.100.1:
> 
> Target iqn.2009.com.test:konrad
>         Lun  0  Path=/dev/VolGroupData/a000,Type=fileio
>         Lun  255  Path=/dev/VolGroupData/a255,Type=fileio
>         Lun  256  Path=/dev/VolGroupData/a256,Type=fileio
>         Lun  512  Path=/dev/VolGroupData_1/b256,Type=fileio
>         Lun  513  Path=/dev/VolGroupData_2/c01,Type=fileio
>         Lun  768  Path=/dev/VolGroupData_2/c256,Type=fileio



-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
