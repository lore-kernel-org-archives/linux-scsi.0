From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Wed, 10 Dec 2008 20:44:24 -0700
Message-ID: <20081211034423.GA26095@parisc-linux.org>
References: <20081210213937.GC25548@parisc-linux.org> <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
Sender: linux-ide-owner@vger.kernel.org
To: Raz Ben-Yehuda <razb@bitband.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 11, 2008 at 12:12:37AM +0200, Raz Ben-Yehuda wrote:
> I did not want to dive into details because it does not matter. Whether
> noop,deadline, deadline parameters...
> As for the controller I used 4 different controllers. Adaptec,AHCI and
> Intel as Integrated chips on the 1025W-UR supermicro motherboard, and a
> 4-th controller SuperMicro UIO Adaptec aac card.
> All gave same results for most dd writes commands.
> dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
> other variants such erase block size ( 128K ) , several erase block size
> and so on. Kernel is 2.6.18-8.el5.

OK, I suspect you aren't giving the drive enough work to do for it to
perform at its best.  Try doing something like this:

for i in $(seq 0 9); do \
	dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct \
		seek=$(($i * 1000)) & \
done

> I used all on a supermicro 1025W-UR. Disks have a SAS interface, 80GB. 
> Also, I would like to note, I have 8 disks in array, while each one
> perform READS 250 MB/s, together I degrade to 200 MB/s each. As for

That doesn't surprise me; you're probably hitting a limitation either of 
the array or the cable itself.  A SAS cable can run up to 6Gbps, which
will be around 600MB/s.  So three drives should be able to saturate your
SAS cable.  If you're using an x4 link, that goes up to 2400MB/s which
should be ample for 8 drives ... maybe you're using a 3Gbps cable which
would limit each drive to 150MB/s.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
