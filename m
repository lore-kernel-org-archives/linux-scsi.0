From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: dm-mpath-rdac.patch problem
Date: Thu, 12 Jul 2007 19:37:43 -0700
Message-ID: <20070713023743.GA5350@us.ibm.com>
References: <4696D6CB.6050504@csupomona.edu>
	<1184292400.5146.45.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1184292400.5146.45.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Copying this mail to linux-scsi and Ccing Andrew Vasquez to possibly
provide input on the Qlogic behavior.

Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> On Thu, 2007-07-12 at 18:35 -0700, Brian De Wolf wrote:
> > Hello All,
> > 
> > I'm not sure if this is the right place for this, but it seems to be the only
> > mailing list related to dm, multipath, and rdac, as far as I can tell.  I've
> > been trying out the dm-mpath-rdac patch (both yesterday's and previous) with
> > gentoo's unstable 2.6.22 kernel, on a Sun x4100 through a QLA2422 HBA (firmware
> > ql2400_fw.bin.4.00.27) to an IBM DS4000.  I am using a version of
> > multipath-tools that I got with git a few days ago.
> > 
> > I've got multipath working, it reports the hwhandler correctly ([hwhandler=1
> > rdac]), and the volume is mountable, etc.  It also shows one link as active, the
> > other as ghost.  However, once the active link dies, the volume becomes read
> > only, and both connections are listed as failed.  Most importantly, something
> > like this shows up in the logs:
> > 
> > Jul 12 17:11:15 jimbo kernel: device-mapper: multipath rdac: queueing
> > MODE_SELECT command on 8:32
> 
> It does look like the rdac hardware handler is doing the right thing and
> the qlogic is dying for some reason.
> 
> I have tested this code in both RHEL5 and SLES10 environments (qla23xx)
> and they work fine. Can you try in one of those and see if it is any
> different.
> 
> Just an FYI w.r.t multipath tools: please remove the patch
> http://git.kernel.org/?p=linux/storage/multipath-
> tools/.git;a=commit;h=e1e1a1bfb2cf76bfd1a49335e3deec5360fb09db from your
> tree for the tools to calculate the path priorities properly.
> 
> 
> > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
> > mbx2=8012h mbx3=8002h.
> > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
> > dumped (ffffc2000171d000) -- ignoring request...
> > Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
> > recovery - ha= ffff81007e85c530.
> > Jul 12 17:11:16 jimbo kernel: device-mapper: multipath: Failing path 8:32.
> > Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 0
> > Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 1
> > Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 2
> > Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 3
> > Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 0
> > Jul 12 17:11:16 jimbo multipathd: 8:32: mark as failed
> > Jul 12 17:11:16 jimbo multipathd: test: remaining active paths: 0
> > 
> > While this may be something for the maintainer of the qla2xxx module (I can't
> > figure out where I'd send it, in that case...) I think it may be of interest
> > that the dm_rdac module tries to push something over the HBA that causes it to
> > bail completely and start from scratch (it starts init processes and loading
> > firmware again).
> > 
> > Not to say that I'm not interested in any help getting this working, that is.
> > If you have any suggestions on how to get this working, I'd love to hear them.
> > I'm also willing to guinea pig some testing if you need it (This box still has a
> > bit before it will have to be put in use).  I may use redhat to ensure that it's
> > not just a broken HBA, but for the long run we would like it to join our gentoo
> > environment.
> > 
> > Thanks!
> > Brian De Wolf
> > 
> > PS- If the subject mislead you because you feel that this is just a qla2xxx
> > problem, I'm sorry for wasting your time.
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> -- 
> 
> ----------------------------------------------------------------------
>     Chandra Seetharaman               | Be careful what you choose....
>               - sekharan@us.ibm.com   |      .......you may get it.
> ----------------------------------------------------------------------
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-andmike
--
Michael Anderson
andmike@us.ibm.com
