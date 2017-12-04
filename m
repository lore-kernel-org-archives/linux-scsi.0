From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [EXT] Re: UFS utilities
Date: Mon, 4 Dec 2017 19:38:33 +0100
Message-ID: <20171204183833.GC13501@kroah.com>
References: <c7f3d6f543ae41c1bb625b1612e47057@SIWEX5A.sing.micron.com>
 <1511811323.2993.13.camel@wdc.com>
 <daba96e0adb146289e3f55bcebeb09f0@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <daba96e0adb146289e3f55bcebeb09f0@SIWEX5A.sing.micron.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 04, 2017 at 03:20:34PM +0000, Bean Huo (beanhuo) wrote:
> Hi, Bart
> Sorry for later!
> >
> >Hello Bean,
> >
> >Please be more specific. What is inconvenient about sg3_utils on embedded
> >ARM systems?
> >
> Exactly, I don't know how to compile sg3_utils with static library, instead of sharing library. I used following configuration
> Parameter:
> ./configure --enable-static=yes --build=x86_64-unknown-linux-gnu --host=aarch64-linux-gnu  --prefix=$PWD/out/  CC=aarch64-linux-gnu-g
>     cc --target=aarch64-linux-gnu LD=aarch64-linux-gnu-ld AS=aarch64-linux-gnu-as CFLAGS=-static LDFLAGS=-static
> 
> But the object files are still dynamically linked.
> 
> ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, 
> for GNU/Linux 3.7.0, BuildID[sha1]=4f01b4c9f1ff47bc00aef93950c02734b4cc8e57, not stripped.
> 
> I want it to be statically linked. Otherwise, I should copy its library to my lib folder, and sometimes for the embedded, 
> Need to re-build rootfs. Meanwhile, for the UFS, there are totally 27 scsi commands being used based on UFS2.1.
> For the most case, we just use several sg3_utils object files, don't need to copy all object files to the ending product. 

So what UFS commands are you missing that you need to see implemented?

And again, have you checked the different forks of the driver?

> >> And also it doesn't support several UFS special command.
> >
> >Are you referring to SCSI commands or rather to UFS commands that fall
> >outside the SCSI spec? Anyway, an approach that is used by many SCSI drivers
> >to export information to user space that falls outside the SCSI spec is to
> >create additional sysfs attributes. See also the sdev_attrs and shost_attrs
> >members of struct scsi_host_template.
> >
> Yes, for the UFS information, I can use these interface/approach to easily get.
> I am thinking how about some testing case and configuration operation.

Which ones exactly?

> Also, is it possible bypass SCSI stacks and go into directly UFS stack?

Look at the different sysfs files for the UFS device, it does that for
some commands.

thanks,

greg k-h
