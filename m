From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: EMCCTD kernel driver Patch for review
Date: Mon, 11 Jan 2016 10:09:51 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4450A32A@G9W0766.americas.hpqcorp.net>
References: <82807C73E0BDBB498164AAE7B8F6A1481C6055F9@MX105CL01.corp.emc.com>
 <DDB9C85B850785449757F9914A034FCB4450A204@G9W0766.americas.hpqcorp.net>
  <82807C73E0BDBB498164AAE7B8F6A1481C6082E4@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C6082E4@MX105CL01.corp.emc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


> [MS>] I did run checkpatch.pl. And yes, there are many warnings as well. About VERSION_CODE
> warning, we actually have to run driver for multiple kernel versions, so does this mean that I
> submit the patch only for current or latest kernel version, and maintain a local copy of driver for
> all other versions ?

I'll give an example from PMC. Look at the upstream hpsa driver and compare that to the driver here (which is the downstream HPE version for SLES/RHEL):

http://sourceforge.net/projects/cciss/files/hpsa-3.0-tarballs/

They are somewhat different and the upstream version does not have any of the #ifdefs etc required to support downstream. Others may chime in but I'd expect that the upstream driver should be aimed at upstream (only) and downstream distro oriented drivers should be maintained out of band. Getting your driver into the kernel has a long term pay off in that it will eventually appear in a downstream distro once they pick up a kernel version that contains it and then they will take fixes for their distros from upstream. I'd expect you'll have a uphill battle getting your driver in if while it contains things like LINUX_VERSION_CODE and contains any other unjustified errors/warnings from checkpatch.pl.

Thanks
Shane
