From: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [PATCH 0/6] v2: Asynchronous function calls to speed up booting and more
Date: Tue, 6 Jan 2009 22:19:33 -0500
Message-ID: <48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
References: <20090105201508.23e98b4b@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105201508.23e98b4b@infradead.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

i can't boot with these patches... the kernel panic was something
along the line of:

ata_piix: device unavailable because of BAR 0 collisions

-Ryan

On 1/5/09, Arjan van de Ven <arjan@infradead.org> wrote:
>
>
>
>
> Hi,
>
> Changes since last version
> * some tweaks to the bootchart script to get better visualization
> * added serialization points in the irq autodetector, module unloading
>   and at rootfs mounting (based on feedback from Linus and Andi)
> * added a second libata patch to scan the partition tables from inside
>   the async code, without global serialization (based on Linus
>   suggestion). This saves a ton of boot time for my box with 2 sata
>   controllers
>
> I talked to David Howells to see if we could share the thread pool code
> (all 35 lines of it), but his requirements are more or less
> incompatible with mine. He needs priorities to be honored, while I need
> to do strict sequencing of events, and this appears to be hardly
> compatible, at least not without adding much more complexity than the
> relatively simple thread code justifies.
>
> parts of the original announcement below; I've updated the two
> bootcharts with the new code; basically my testbox is going from 2.75
> seconds to 1.0 seconds (approximately).. which is not a bad gain at all.
>
> I've also stuck the patches in a git tree; the git info is:
>
> The following changes since commit 238c6d54830c624f34ac9cf123ac04aebfca5013:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../agk/linux-2.6-dm
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async.git
> master
>
> Arjan van de Ven (6):
>       fastboot: Asynchronous function calls to speed up kernel boot
>       fastboot: make scsi probes asynchronous
>       fastboot: make the libata port scan asynchronous
>       fastboot: make ACPI bus drivers probe asynchronous
>       bootchart: improve output based on Dave Jones' feedback
>       fastboot: Make libata initialization even more async
>
>  drivers/acpi/scan.c       |   23 +++-
>  drivers/ata/libata-core.c |   96 ++++++++-------
>  drivers/scsi/scsi_scan.c  |    3 +
>  drivers/scsi/sd.c         |  109 ++++++++++------
>  include/linux/async.h     |   21 +++
>  init/do_mounts.c          |    2 +
>  init/main.c               |    5 +-
>  kernel/Makefile           |    3 +-
>  kernel/async.c            |  307
> +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq/autoprobe.c    |    5 +
>  kernel/module.c           |    2 +
>  scripts/bootgraph.pl      |   16 ++-
>  12 files changed, 491 insertions(+), 101 deletions(-)
>  create mode 100644 include/linux/async.h
>  create mode 100644 kernel/async.c
>
>
> should this go via -tip? is the first patch simple enough for .29 so that
> the later ones can go via the maintainer trees after that?
>
>
> =====
>
> This patch series introduces asynchronous function calls.
> The goal is still the same (boot faster), the method is entirely
> different.
>
> Asynchronous function calls allow drivers and subsystems to do
> operations asynchronously, while providing a mechanism to serialize
> the asynchronous operations at "externally visible" locations, such as
> device number registrations.
>
> As such, this approach is NOT a "full parallel kernel init".
> For one, it keeps device numbers stable. For another, it's very much
> opt-in for any code using this.
>
> Rather, it is more comparable to an out-of-order cpu, where computations
> are done asynchronously, but are retired in program order.
>
> This series first introduces the infrastructure in patch 1,
> and then adds users of this infrastructure (scsi in patch2, libata in
> patch 3 and acpi in patch 4).
>
> To see this working, I uploaded a "before" and "after" kernel bootchart
> for one of my testboxes at
>
> http://www.kernel.org/pub/linux/kernel/people/arjan/async/before.svg
> http://www.kernel.org/pub/linux/kernel/people/arjan/async/after.svg
>
> [minor note; the "after" one also has Alan's suggestion to tweak the
> serial config option]
>
> As you can see with inkscape (or gimp or any other svg viewer), there
> is still some room for doing more things in parallel, but the 3 example
> usage patches are a big win already.
>
>
> --
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
