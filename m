From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/8] RFC: Introduce ida_simple interfaces and use them.
Date: Fri, 22 Jul 2011 17:48:38 +0100
Message-ID: <4E29A9E6.3080308@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie
List-Id: linux-scsi@vger.kernel.org

Gah,

Sorry all, I have no idea why this double sent.

Jonathan
> Hi All,
> 
> Firstly sorry for the huge cc list, but this series does get about.
> 
> This series came out of two separate lkml threads:
> 
> https://lkml.org/lkml/2011/7/13/64
> http://thread.gmane.org/gmane.linux.kernel/1148513/focus=74236
> 
> Basically Rusty and I both got annoyed with yet more instances
> of the same cut and past ida allocation code for the very simple
> case of wanting a unique id for some device. Tejun helpfully
> joined the two threads up.
> 
> Anyhow, Rusty proposed more or less the first patch here (with a name
> change requested by Tejun applied.)
> 
> The others patches are some of the more obvious looking cases for
> applying this code.  My original reason was for IIO but those patches will
> have to wait a little while for some prior changes to merge.
> For reference, it saves about 40 lines there so I'm happy ;)
> 
> There are a number of other cases in tree that can be cleaned up
> in a second series once these are sorted.
> 
> There are a couple of cases in here where I've carefully mangled
> the error codes to keep consistent with the existing code.  Please
> can people who know those subsystems well decide on whether the
> mangling is necessary.
> 
> All comments welcome. I expect I've broken at least one driver
> doing this so please take a close look.
> 
> Rusty, Tejun. I kept your sign of an ack for the first patch. Could
> you quickly verify that's fine?
> 
> Thanks,
> 
> Jonathan
> 
> Jonathan Cameron (7):
>   hwmon: convert idr to ida and use ida_simple interface.
>   hwmon: ibmaem: convert idr to ida and use ida_simple_get
>   [SCSI] use ida_simple_get and ida_simple remove in place of
>     boilerplate code.
>   drm/vmwgfx: use ida_simple_get for id allocation.
>   [SCSI] osduld: use ida_simple_get to handle id.
>   w1: ds2760 and ds2780, use ida for id and ida_simple_get to get it.
>   rtc: class idr converted to ida and ida_simple_get used.
> 
> Rusty Russell (1):
>   ida: Simplified functions for id allocation.
> 
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c |   34 +++----------
>  drivers/hwmon/hwmon.c                         |   32 +++---------
>  drivers/hwmon/ibmaem.c                        |   47 +++--------------
>  drivers/rtc/class.c                           |   32 +++---------
>  drivers/scsi/osd/osd_uld.c                    |   22 +++-----
>  drivers/scsi/sd.c                             |   32 ++++--------
>  drivers/w1/slaves/w1_ds2760.c                 |   48 ++---------------
>  drivers/w1/slaves/w1_ds2780.c                 |   48 ++---------------
>  include/linux/idr.h                           |    4 ++
>  lib/idr.c                                     |   67 +++++++++++++++++++++++++
>  10 files changed, 134 insertions(+), 232 deletions(-)
> 
