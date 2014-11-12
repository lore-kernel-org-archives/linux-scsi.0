From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 31/37] sun3_scsi: Adopt atari_NCR5380 core driver and remove sun3_NCR5380.c
Date: Wed, 12 Nov 2014 16:12:17 +1100
Message-ID: <20141112051153.805493450@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=sun3_scsi-adopt-atari_NCR5380
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Given the preceding changes to atari_NCR5380.c, this patch should not c=
hange
behaviour of the sun3_scsi and sun3_scsi_vme modules.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 MAINTAINERS                 |    1=20
 drivers/scsi/sun3_NCR5380.c | 2849 -----------------------------------=
---------
 drivers/scsi/sun3_scsi.c    |   10=20
 3 files changed, 6 insertions(+), 2854 deletions(-)

Index: linux/drivers/scsi/sun3_scsi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:31.000000000 +=
1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-12 16:11:37.000000000 +1100
@@ -41,6 +41,8 @@
 #define REAL_DMA
 #define RESET_RUN_DONE
 /* #define SUPPORT_TAGS */
+/* minimum number of bytes to do dma on */
+#define DMA_MIN_SIZE                    129
=20
 /* #define MAX_TAGS                     32 */
=20
@@ -64,6 +66,9 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) &=
 SR_IO))
=20
+#define NCR5380_acquire_dma_irq(instance)    (1)
+#define NCR5380_release_dma_irq(instance)
+
 #include "NCR5380.h"
=20
=20
@@ -92,9 +97,6 @@ module_param(setup_hostid, int, 0);
 /* dvma buffer to allocate -- 32k should hopefully be more than suffic=
ient */
 #define SUN3_DVMA_BUFSIZE 0xe000
=20
-/* minimum number of bytes to do dma on */
-#define SUN3_DMA_MINSIZE 128
-
 static struct scsi_cmnd *sun3_dma_setup_done;
 static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
@@ -486,7 +488,7 @@ static int sun3scsi_dma_finish(int write
=20
 }
 =09
-#include "sun3_NCR5380.c"
+#include "atari_NCR5380.c"
=20
 #ifdef SUN3_SCSI_VME
 #define SUN3_SCSI_NAME          "Sun3 NCR5380 VME SCSI"
Index: linux/MAINTAINERS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/MAINTAINERS	2014-11-12 16:10:42.000000000 +1100
+++ linux/MAINTAINERS	2014-11-12 16:11:37.000000000 +1100
@@ -6171,7 +6171,6 @@ F:	drivers/scsi/g_NCR5380.*
 F:	drivers/scsi/g_NCR5380_mmio.c
 F:	drivers/scsi/mac_scsi.*
 F:	drivers/scsi/pas16.*
-F:	drivers/scsi/sun3_NCR5380.c
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
 F:	drivers/scsi/t128.*
Index: linux/drivers/scsi/sun3_NCR5380.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:11:31.00000000=
0 +1100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,2849 +0,0 @@
-/* sun3_NCR5380.c -- adapted from atari_NCR5380.c for the sun3 by=20
-   Sam Creasey. */=20
-/*=20
- * NCR 5380 generic driver routines.  These should make it *trivial*
- * 	to implement 5380 SCSI drivers under Linux with a non-trantor
- *	architecture.
- *
- *	Note that these routines also work with NR53c400 family chips.
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing=20
- *	(Unix and Linux consulting and custom programming)
- * 	drew@colorado.edu
- *	+1 (303) 666-5836
- *
- * For more information, please consult=20
- *
- * NCR 5380 Family
- * SCSI Protocol Controller
- * Databook
- *
- * NCR Microelectronics
- * 1635 Aeroplaza Drive
- * Colorado Springs, CO 80916
- * 1+ (719) 578-3400
- * 1+ (800) 334-5454
- */
-
-/*
- * ++roman: To port the 5380 driver to the Atari, I had to do some cha=
nges in
- * this file, too:
- *
- *  - Some of the debug statements were incorrect (undefined variables=
 and the
- *    like). I fixed that.
- *
- *  - In information_transfer(), I think a #ifdef was wrong. Looking a=
t the
- *    possible DMA transfer size should also happen for REAL_DMA. I ad=
ded this
- *    in the #if statement.
- *
- *  - When using real DMA, information_transfer() should return in a D=
ATAOUT
- *    phase after starting the DMA. It has nothing more to do.
- *
- *  - The interrupt service routine should run main after end of DMA, =
too (not
- *    only after RESELECTION interrupts). Additionally, it should _not=
_ test
- *    for more interrupts after running main, since a DMA process may =
have
- *    been started and interrupts are turned on now. The new int could=
 happen
- *    inside the execution of NCR5380_intr(), leading to recursive
- *    calls.
- *
- * - I've deleted all the stuff for AUTOPROBE_IRQ, REAL_DMA_POLL, PSEU=
DO_DMA
- *    and USLEEP, because these were messing up readability and will n=
ever be
- *    needed for Atari SCSI.
- *=20
- * - I've revised the NCR5380_main() calling scheme (relax the 'main_r=
unning'
- *   stuff), and 'main' is executed in a bottom half if awoken by an
- *   interrupt.
- *
- * - The code was quite cluttered up by "#if (NDEBUG & NDEBUG_*) print=
k..."
- *   constructs. In my eyes, this made the source rather unreadable, s=
o I
- *   finally replaced that by the *_PRINTK() macros.
- *
- */
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_transport_spi.h>
-
-/*
- * Further development / testing that should be done :=20
- * 1.  Test linked command handling code after Eric is ready with=20
- *     the high level code.
- */
-
-#if (NDEBUG & NDEBUG_LISTS)
-#define LIST(x,y) \
-  { printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*=
)(y)); \
-    if ((x)=3D=3D(y)) udelay(5); }
-#define REMOVE(w,x,y,z) \
-  { printk("LINE:%d   Removing: %p->%p  %p->%p \n", __LINE__, \
-	   (void*)(w), (void*)(x), (void*)(y), (void*)(z)); \
-    if ((x)=3D=3D(y)) udelay(5); }
-#else
-#define LIST(x,y)
-#define REMOVE(w,x,y,z)
-#endif
-
-#ifndef notyet
-#undef LINKED
-#endif
-
-/*
- * Design
- * Issues :
- *
- * The other Linux SCSI drivers were written when Linux was Intel PC-o=
nly,
- * and specifically for each board rather than each chip.  This makes =
their
- * adaptation to platforms like the Mac (Some of which use NCR5380's)
- * more difficult than it has to be.
- *
- * Also, many of the SCSI drivers were written before the command queu=
ing
- * routines were implemented, meaning their implementations of queued=20
- * commands were hacked on rather than designed in from the start.
- *
- * When I designed the Linux SCSI drivers I figured that=20
- * while having two different SCSI boards in a system might be useful
- * for debugging things, two of the same type wouldn't be used.
- * Well, I was wrong and a number of users have mailed me about runnin=
g
- * multiple high-performance SCSI boards in a server.
- *
- * Finally, when I get questions from users, I have no idea what=20
- * revision of my driver they are running.
- *
- * This driver attempts to address these problems :
- * This is a generic 5380 driver.  To use it on a different platform,=20
- * one simply writes appropriate system specific macros (ie, data
- * transfer - some PC's will use the I/O bus, 68K's must use=20
- * memory mapped) and drops this file in their 'C' wrapper.
- *
- * As far as command queueing, two queues are maintained for=20
- * each 5380 in the system - commands that haven't been issued yet,
- * and commands that are currently executing.  This means that an=20
- * unlimited number of commands may be queued, letting=20
- * more commands propagate from the higher driver levels giving higher=
=20
- * throughput.  Note that both I_T_L and I_T_L_Q nexuses are supported=
,=20
- * allowing multiple commands to propagate all the way to a SCSI-II de=
vice=20
- * while a command is already executing.
- *
- * To solve the multiple-boards-in-the-same-system problem,=20
- * there is a separate instance structure for each instance
- * of a 5380 in the system.  So, multiple NCR5380 drivers will
- * be able to coexist with appropriate changes to the high level
- * SCSI code. =20
- *
- * Issues specific to the NCR5380 :=20
- *
- * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead=20
- * piece of hardware that requires you to sit in a loop polling for=20
- * the REQ signal as long as you are connected.  Some devices are=20
- * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect=20
- * while doing long seek operations.
- *=20
- * The workaround for this is to keep track of devices that have
- * disconnected.  If the device hasn't disconnected, for commands that
- * should disconnect, we do something like=20
- *
- * while (!REQ is asserted) { sleep for N usecs; poll for M usecs }
- *=20
- * Some tweaking of N and M needs to be done.  An algorithm based=20
- * on "time to data" would give the best results as long as short time
- * to datas (ie, on the same track) were considered, however these=20
- * broken devices are the exception rather than the rule and I'd rathe=
r
- * spend my time optimizing for the normal case.
- *
- * Architecture :
- *
- * At the heart of the design is a coroutine, NCR5380_main,
- * which is started when not running by the interrupt handler,
- * timer, and queue command function.  It attempts to establish
- * I_T_L or I_T_L_Q nexuses by removing the commands from the=20
- * issue queue and calling NCR5380_select() if a nexus=20
- * is not established.=20
- *
- * Once a nexus is established, the NCR5380_information_transfer()
- * phase goes through the various phases as instructed by the target.
- * if the target goes into MSG IN and sends a DISCONNECT message,
- * the command structure is placed into the per instance disconnected
- * queue, and NCR5380_main tries to find more work.  If USLEEP
- * was defined, and the target is idle for too long, the system
- * will try to sleep.
- *
- * If a command has disconnected, eventually an interrupt will trigger=
,
- * calling NCR5380_intr()  which will in turn call NCR5380_reselect
- * to reestablish a nexus.  This will run main if necessary.
- *
- * On command termination, the done function will be called as=20
- * appropriate.
- *
- * SCSI pointers are maintained in the SCp field of SCSI command=20
- * structures, being initialized after the command is connected
- * in NCR5380_select, and set as appropriate in NCR5380_information_tr=
ansfer.
- * Note that in violation of the standard, an implicit SAVE POINTERS o=
peration
- * is done, since some BROKEN disks fail to issue an explicit SAVE POI=
NTERS.
- */
-
-/*
- * Using this file :
- * This file a skeleton Linux SCSI driver for the NCR 5380 series
- * of chips.  To use it, you write an architecture specific functions=20
- * and macros and include this file in your driver.
- *
- * These macros control options :=20
- * AUTOSENSE - if defined, REQUEST SENSE will be performed automatical=
ly
- *	for commands that return with a CHECK CONDITION status.=20
- *
- * LINKED - if defined, linked commands are supported.
- *
- * REAL_DMA - if defined, REAL DMA is used during the data transfer ph=
ases.
- *
- * SUPPORT_TAGS - if defined, SCSI-2 tagged queuing is used where poss=
ible
- *
- * These macros MUST be defined :
- *=20
- * NCR5380_read(register)  - read from the specified register
- *
- * NCR5380_write(register, value) - write to the specific register=20
- *
- * Either real DMA *or* pseudo DMA may be implemented
- * REAL functions :=20
- * NCR5380_REAL_DMA should be defined if real DMA is to be used.
- * Note that the DMA setup functions should return the number of bytes=
=20
- *	that they were able to program the controller for.
- *
- * Also note that generic i386/PC versions of these macros are=20
- *	available as NCR5380_i386_dma_write_setup,
- *	NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
- *
- * NCR5380_dma_write_setup(instance, src, count) - initialize
- * NCR5380_dma_read_setup(instance, dst, count) - initialize
- * NCR5380_dma_residual(instance); - residual count
- *
- * PSEUDO functions :
- * NCR5380_pwrite(instance, src, count)
- * NCR5380_pread(instance, dst, count);
- *
- * If nothing specific to this implementation needs doing (ie, with ex=
ternal
- * hardware), you must also define=20
- * =20
- * NCR5380_queue_command
- * NCR5380_reset
- * NCR5380_abort
- *
- * to be the global entry points into the specific driver, ie=20
- * #define NCR5380_queue_command t128_queue_command.
- *
- * If this is not done, the routines will be defined as static functio=
ns
- * with the NCR5380* names and the user must provide a globally
- * accessible wrapper function.
- *
- * The generic driver is initialized by calling NCR5380_init(instance)=
,
- * after setting the appropriate host specific fields and ID.  If the=20
- * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(i=
nstance,
- * possible) function may be used.
- */
-
-static struct Scsi_Host *first_instance =3D NULL;
-static struct scsi_host_template *the_template =3D NULL;
-
-/* Macros ease life... :-) */
-#define	SETUP_HOSTDATA(in)				\
-    struct NCR5380_hostdata *hostdata =3D			\
-	(struct NCR5380_hostdata *)(in)->hostdata
-#define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
-
-#define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
-#define	SET_NEXT(cmd, next)	((cmd)->host_scribble =3D (void *)(next))
-#define	NEXTADDR(cmd)		((struct scsi_cmnd **)&((cmd)->host_scribble))
-
-#define	HOSTNO		instance->host_no
-#define	H_NO(cmd)	(cmd)->device->host->host_no
-
-#define SGADDR(buffer) (void *)(((unsigned long)sg_virt(((buffer)))))
-
-#ifdef SUPPORT_TAGS
-
-/*
- * Functions for handling tagged queuing
- * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- *
- * ++roman (01/96): Now I've implemented SCSI-2 tagged queuing. Some n=
otes:
- *
- * Using consecutive numbers for the tags is no good idea in my eyes. =
There
- * could be wrong re-usings if the counter (8 bit!) wraps and some ear=
ly
- * command has been preempted for a long time. My solution: a bitfield=
 for
- * remembering used tags.
- *
- * There's also the problem that each target has a certain queue size,=
 but we
- * cannot know it in advance :-( We just see a QUEUE_FULL status being
- * returned. So, in this case, the driver internal queue size assumpti=
on is
- * reduced to the number of active tags if QUEUE_FULL is returned by t=
he
- * target. The command is returned to the mid-level, but with status c=
hanged
- * to BUSY, since --as I've seen-- the mid-level can't handle QUEUE_FU=
LL
- * correctly.
- *
- * We're also not allowed running tagged commands as long as an untagg=
ed
- * command is active. And REQUEST SENSE commands after a contingent al=
legiance
- * condition _must_ be untagged. To keep track whether an untagged com=
mand has
- * been issued, the host->busy array is still employed, as it is witho=
ut
- * support for tagged queuing.
- *
- * One could suspect that there are possible race conditions between
- * is_lun_busy(), cmd_get_tag() and cmd_free_tag(). But I think this i=
sn't the
- * case: is_lun_busy() and cmd_get_tag() are both called from NCR5380_=
main(),
- * which already guaranteed to be running at most once. It is also the=
 only
- * place where tags/LUNs are allocated. So no other allocation can sli=
p
- * between that pair, there could only happen a reselection, which can=
 free a
- * tag, but that doesn't hurt. Only the sequence in cmd_free_tag() bec=
omes
- * important: the tag bit must be cleared before 'nr_allocated' is dec=
reased.
- */
-
-/* For the m68k, the number of bits in 'allocated' must be a multiple =
of 32! */
-#if (MAX_TAGS % 32) !=3D 0
-#error "MAX_TAGS must be a multiple of 32!"
-#endif
-
-typedef struct {
-    char	allocated[MAX_TAGS/8];
-    int		nr_allocated;
-    int		queue_size;
-} TAG_ALLOC;
-
-static TAG_ALLOC TagAlloc[8][8]; /* 8 targets and 8 LUNs */
-
-
-static void __init init_tags( void )
-{
-    int target, lun;
-    TAG_ALLOC *ta;
-   =20
-    if (!setup_use_tagged_queuing)
-	return;
-   =20
-    for( target =3D 0; target < 8; ++target ) {
-	for( lun =3D 0; lun < 8; ++lun ) {
-	    ta =3D &TagAlloc[target][lun];
-	    memset( &ta->allocated, 0, MAX_TAGS/8 );
-	    ta->nr_allocated =3D 0;
-	    /* At the beginning, assume the maximum queue size we could
-	     * support (MAX_TAGS). This value will be decreased if the target
-	     * returns QUEUE_FULL status.
-	     */
-	    ta->queue_size =3D MAX_TAGS;
-	}
-    }
-}
-
-
-/* Check if we can issue a command to this LUN: First see if the LUN i=
s marked
- * busy by an untagged command. If the command should use tagged queui=
ng, also
- * check that there is a free tag and the target's queue won't overflo=
w. This
- * function should be called with interrupts disabled to avoid race
- * conditions.
- */=20
-
-static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
-{
-    u8 lun =3D cmd->device->lun;
-    SETUP_HOSTDATA(cmd->device->host);
-
-    if (hostdata->busy[cmd->device->id] & (1 << lun))
-	return( 1 );
-    if (!should_be_tagged ||
-	!setup_use_tagged_queuing || !cmd->device->tagged_supported)
-	return( 0 );
-    if (TagAlloc[cmd->device->id][lun].nr_allocated >=3D
-	TagAlloc[cmd->device->id][lun].queue_size ) {
-	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d: no free tags\n",
-		    H_NO(cmd), cmd->device->id, lun );
-	return( 1 );
-    }
-    return( 0 );
-}
-
-
-/* Allocate a tag for a command (there are no checks anymore, check_lu=
n_busy()
- * must be called before!), or reserve the LUN in 'busy' if the comman=
d is
- * untagged.
- */
-
-static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
-{
-    u8 lun =3D cmd->device->lun;
-    SETUP_HOSTDATA(cmd->device->host);
-
-    /* If we or the target don't support tagged queuing, allocate the =
LUN for
-     * an untagged command.
-     */
-    if (!should_be_tagged ||
-	!setup_use_tagged_queuing || !cmd->device->tagged_supported) {
-	cmd->tag =3D TAG_NONE;
-	hostdata->busy[cmd->device->id] |=3D (1 << lun);
-	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d now allocated by unta=
gged "
-		    "command\n", H_NO(cmd), cmd->device->id, lun );
-    }
-    else {
-	TAG_ALLOC *ta =3D &TagAlloc[cmd->device->id][lun];
-
-	cmd->tag =3D find_first_zero_bit( &ta->allocated, MAX_TAGS );
-	set_bit( cmd->tag, &ta->allocated );
-	ta->nr_allocated++;
-	dprintk(NDEBUG_TAGS,  "scsi%d: using tag %d for target %d lun %d "
-		    "(now %d tags in use)\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, lun,
-		    ta->nr_allocated );
-    }
-}
-
-
-/* Mark the tag of command 'cmd' as free, or in case of an untagged co=
mmand,
- * unlock the LUN.
- */
-
-static void cmd_free_tag(struct scsi_cmnd *cmd)
-{
-    u8 lun =3D cmd->device->lun;
-    SETUP_HOSTDATA(cmd->device->host);
-
-    if (cmd->tag =3D=3D TAG_NONE) {
-	hostdata->busy[cmd->device->id] &=3D ~(1 << lun);
-	dprintk(NDEBUG_TAGS,  "scsi%d: target %d lun %d untagged cmd finished=
\n",
-		    H_NO(cmd), cmd->device->id, lun );
-    }
-    else if (cmd->tag >=3D MAX_TAGS) {
-	printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
-		H_NO(cmd), cmd->tag );
-    }
-    else {
-	TAG_ALLOC *ta =3D &TagAlloc[cmd->device->id][lun];
-	clear_bit( cmd->tag, &ta->allocated );
-	ta->nr_allocated--;
-	dprintk(NDEBUG_TAGS,  "scsi%d: freed tag %d for target %d lun %d\n",
-		    H_NO(cmd), cmd->tag, cmd->device->id, lun );
-    }
-}
-
-
-static void free_all_tags( void )
-{
-    int target, lun;
-    TAG_ALLOC *ta;
-
-    if (!setup_use_tagged_queuing)
-	return;
-   =20
-    for( target =3D 0; target < 8; ++target ) {
-	for( lun =3D 0; lun < 8; ++lun ) {
-	    ta =3D &TagAlloc[target][lun];
-	    memset( &ta->allocated, 0, MAX_TAGS/8 );
-	    ta->nr_allocated =3D 0;
-	}
-    }
-}
-
-#endif /* SUPPORT_TAGS */
-
-
-/*
- * Function : void initialize_SCp(struct scsi_cmnd *cmd)
- *
- * Purpose : initialize the saved data pointers for cmd to point to th=
e=20
- *	start of the buffer.
- *
- * Inputs : cmd - struct scsi_cmnd structure to have pointers reset.
- */
-
-static __inline__ void initialize_SCp(struct scsi_cmnd *cmd)
-{
-    /*=20
-     * Initialize the Scsi Pointer field so that all of the commands i=
n the=20
-     * various queues are valid.
-     */
-
-    if (scsi_bufflen(cmd)) {
-	cmd->SCp.buffer =3D scsi_sglist(cmd);
-	cmd->SCp.buffers_residual =3D scsi_sg_count(cmd) - 1;
-	cmd->SCp.ptr =3D (char *) SGADDR(cmd->SCp.buffer);
-	cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
-    } else {
-	cmd->SCp.buffer =3D NULL;
-	cmd->SCp.buffers_residual =3D 0;
-	cmd->SCp.ptr =3D NULL;
-	cmd->SCp.this_residual =3D 0;
-    }
-   =20
-}
-
-#include <linux/delay.h>
-
-#if NDEBUG
-static struct {
-    unsigned char mask;
-    const char * name;}=20
-signals[] =3D {{ SR_DBP, "PARITY"}, { SR_RST, "RST" }, { SR_BSY, "BSY"=
 },=20
-    { SR_REQ, "REQ" }, { SR_MSG, "MSG" }, { SR_CD,  "CD" }, { SR_IO, "=
IO" },=20
-    { SR_SEL, "SEL" }, {0, NULL}},=20
-basrs[] =3D {{BASR_ATN, "ATN"}, {BASR_ACK, "ACK"}, {0, NULL}},
-icrs[] =3D {{ICR_ASSERT_RST, "ASSERT RST"},{ICR_ASSERT_ACK, "ASSERT AC=
K"},
-    {ICR_ASSERT_BSY, "ASSERT BSY"}, {ICR_ASSERT_SEL, "ASSERT SEL"},=20
-    {ICR_ASSERT_ATN, "ASSERT ATN"}, {ICR_ASSERT_DATA, "ASSERT DATA"},=20
-    {0, NULL}},
-mrs[] =3D {{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"}, {MR_TARGET, "MODE TA=
RGET"},=20
-    {MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"}, {MR_ENABLE_PAR_INTR,=20
-    "MODE PARITY INTR"}, {MR_ENABLE_EOP_INTR,"MODE EOP INTR"},
-    {MR_MONITOR_BSY, "MODE MONITOR BSY"},
-    {MR_DMA_MODE, "MODE DMA"}, {MR_ARBITRATE, "MODE ARBITRATION"},=20
-    {0, NULL}};
-
-/*
- * Function : void NCR5380_print(struct Scsi_Host *instance)
- *
- * Purpose : print the SCSI bus signals for debugging purposes
- *
- * Input : instance - which NCR5380
- */
-
-static void NCR5380_print(struct Scsi_Host *instance) {
-    unsigned char status, data, basr, mr, icr, i;
-    unsigned long flags;
-
-    local_irq_save(flags);
-    data =3D NCR5380_read(CURRENT_SCSI_DATA_REG);
-    status =3D NCR5380_read(STATUS_REG);
-    mr =3D NCR5380_read(MODE_REG);
-    icr =3D NCR5380_read(INITIATOR_COMMAND_REG);
-    basr =3D NCR5380_read(BUS_AND_STATUS_REG);
-    local_irq_restore(flags);
-    printk("STATUS_REG: %02x ", status);
-    for (i =3D 0; signals[i].mask ; ++i)=20
-	if (status & signals[i].mask)
-	    printk(",%s", signals[i].name);
-    printk("\nBASR: %02x ", basr);
-    for (i =3D 0; basrs[i].mask ; ++i)=20
-	if (basr & basrs[i].mask)
-	    printk(",%s", basrs[i].name);
-    printk("\nICR: %02x ", icr);
-    for (i =3D 0; icrs[i].mask; ++i)=20
-	if (icr & icrs[i].mask)
-	    printk(",%s", icrs[i].name);
-    printk("\nMODE: %02x ", mr);
-    for (i =3D 0; mrs[i].mask; ++i)=20
-	if (mr & mrs[i].mask)
-	    printk(",%s", mrs[i].name);
-    printk("\n");
-}
-
-static struct {
-    unsigned char value;
-    const char *name;
-} phases[] =3D {
-    {PHASE_DATAOUT, "DATAOUT"}, {PHASE_DATAIN, "DATAIN"}, {PHASE_CMDOU=
T, "CMDOUT"},
-    {PHASE_STATIN, "STATIN"}, {PHASE_MSGOUT, "MSGOUT"}, {PHASE_MSGIN, =
"MSGIN"},
-    {PHASE_UNKNOWN, "UNKNOWN"}};
-
-/*=20
- * Function : void NCR5380_print_phase(struct Scsi_Host *instance)
- *
- * Purpose : print the current SCSI phase for debugging purposes
- *
- * Input : instance - which NCR5380
- */
-
-static void NCR5380_print_phase(struct Scsi_Host *instance)
-{
-    unsigned char status;
-    int i;
-
-    status =3D NCR5380_read(STATUS_REG);
-    if (!(status & SR_REQ))=20
-	printk(KERN_DEBUG "scsi%d: REQ not asserted, phase unknown.\n", HOSTN=
O);
-    else {
-	for (i =3D 0; (phases[i].value !=3D PHASE_UNKNOWN) &&=20
-	    (phases[i].value !=3D (status & PHASE_MASK)); ++i);=20
-	printk(KERN_DEBUG "scsi%d: phase %s\n", HOSTNO, phases[i].name);
-    }
-}
-
-#endif
-
-/*
- * ++roman: New scheme of calling NCR5380_main()
- *=20
- * If we're not in an interrupt, we can call our main directly, it can=
not be
- * already running. Else, we queue it on a task queue, if not 'main_ru=
nning'
- * tells us that a lower level is already executing it. This way,
- * 'main_running' needs not be protected in a special way.
- *
- * queue_main() is a utility function for putting our main onto the ta=
sk
- * queue, if main_running is false. It should be called only from a
- * interrupt or bottom half.
- */
-
-#include <linux/gfp.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-
-static volatile int main_running =3D 0;
-static DECLARE_WORK(NCR5380_tqueue, NCR5380_main);
-
-static __inline__ void queue_main(void)
-{
-    if (!main_running) {
-	/* If in interrupt and NCR5380_main() not already running,
-	   queue it on the 'immediate' task queue, to be processed
-	   immediately after the current interrupt processing has
-	   finished. */
-	schedule_work(&NCR5380_tqueue);
-    }
-    /* else: nothing to do: the running NCR5380_main() will pick up
-       any newly queued command. */
-}
-
-
-static inline void NCR5380_all_init (void)
-{
-    static int done =3D 0;
-    if (!done) {
-	dprintk(NDEBUG_INIT, "scsi : NCR5380_all_init()\n");
-	done =3D 1;
-    }
-}
-
-/**
- * NCR58380_info - report driver and host information
- * @instance: relevant scsi host instance
- *
- * For use as the host template info() handler.
- *
- * Locks: none
- */
-
-static const char *NCR5380_info(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
-
-	return hostdata->info;
-}
-
-static void prepare_info(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
-
-	snprintf(hostdata->info, sizeof(hostdata->info),
-	         "%s, io_port 0x%lx, n_io_port %d, "
-	         "base 0x%lx, irq %d, "
-	         "can_queue %d, cmd_per_lun %d, "
-	         "sg_tablesize %d, this_id %d, "
-	         "options { %s} ",
-	         instance->hostt->name, instance->io_port, instance->n_io_por=
t,
-	         instance->base, instance->irq,
-	         instance->can_queue, instance->cmd_per_lun,
-	         instance->sg_tablesize, instance->this_id,
-#ifdef DIFFERENTIAL
-	         "DIFFERENTIAL "
-#endif
-#ifdef REAL_DMA
-	         "REAL_DMA "
-#endif
-#ifdef PARITY
-	         "PARITY "
-#endif
-#ifdef SUPPORT_TAGS
-	         "SUPPORT_TAGS "
-#endif
-	         "");
-}
-
-/*
- * Function : void NCR5380_print_status (struct Scsi_Host *instance)
- *
- * Purpose : print commands in the various queues, called from
- *	NCR5380_abort and NCR5380_debug to aid debugging.
- *
- * Inputs : instance, pointer to this instance. =20
- */
-
-static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd)
-{
-	int i, s;
-	unsigned char *command;
-	printk("scsi%d: destination target %d, lun %llu\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
-	printk(KERN_CONT "        command =3D ");
-	command =3D cmd->cmnd;
-	printk(KERN_CONT "%2d (0x%02x)", command[0], command[0]);
-	for (i =3D 1, s =3D COMMAND_SIZE(command[0]); i < s; ++i)
-		printk(KERN_CONT " %02x", command[i]);
-	printk("\n");
-}
-
-static void NCR5380_print_status(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata;
-	struct scsi_cmnd *ptr;
-	unsigned long flags;
-
-	NCR5380_dprint(NDEBUG_ANY, instance);
-	NCR5380_dprint_phase(NDEBUG_ANY, instance);
-
-	hostdata =3D (struct NCR5380_hostdata *)instance->hostdata;
-
-	local_irq_save(flags);
-	printk("NCR5380: coroutine is%s running.\n",
-		main_running ? "" : "n't");
-	if (!hostdata->connected)
-		printk("scsi%d: no currently connected command\n", HOSTNO);
-	else
-		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected);
-	printk("scsi%d: issue_queue\n", HOSTNO);
-	for (ptr =3D (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr =3D =
NEXT(ptr))
-		lprint_Scsi_Cmnd(ptr);
-
-	printk("scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr =3D (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
-	     ptr =3D NEXT(ptr))
-		lprint_Scsi_Cmnd(ptr);
-
-	local_irq_restore(flags);
-	printk("\n");
-}
-
-static void show_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
-{
-	int i, s;
-	unsigned char *command;
-	seq_printf(m, "scsi%d: destination target %d, lun %llu\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
-	seq_printf(m, "        command =3D ");
-	command =3D cmd->cmnd;
-	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
-	for (i =3D 1, s =3D COMMAND_SIZE(command[0]); i < s; ++i)
-		seq_printf(m, " %02x", command[i]);
-	seq_printf(m, "\n");
-}
-
-static int __maybe_unused NCR5380_show_info(struct seq_file *m,
-                                            struct Scsi_Host *instance=
)
-{
-	struct NCR5380_hostdata *hostdata;
-	struct scsi_cmnd *ptr;
-	unsigned long flags;
-
-	hostdata =3D (struct NCR5380_hostdata *)instance->hostdata;
-
-	local_irq_save(flags);
-	seq_printf(m, "NCR5380: coroutine is%s running.\n",
-		main_running ? "" : "n't");
-	if (!hostdata->connected)
-		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
-	else
-		show_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
-	seq_printf(m, "scsi%d: issue_queue\n", HOSTNO);
-	for (ptr =3D (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr =3D =
NEXT(ptr))
-		show_Scsi_Cmnd(ptr, m);
-
-	seq_printf(m, "scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr =3D (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
-	     ptr =3D NEXT(ptr))
-		show_Scsi_Cmnd(ptr, m);
-
-	local_irq_restore(flags);
-	return 0;
-}
-
-/*=20
- * Function : void NCR5380_init (struct Scsi_Host *instance)
- *
- * Purpose : initializes *instance and corresponding 5380 chip.
- *
- * Inputs : instance - instantiation of the 5380 driver. =20
- *
- * Notes : I assume that the host, hostno, and id bits have been
- * 	set correctly.  I don't care about the irq and other fields.=20
- *=20
- */
-
-static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
-{
-    int i;
-    SETUP_HOSTDATA(instance);
-
-    NCR5380_all_init();
-
-    hostdata->aborted =3D 0;
-    hostdata->id_mask =3D 1 << instance->this_id;
-    hostdata->id_higher_mask =3D 0;
-    for (i =3D hostdata->id_mask; i <=3D 0x80; i <<=3D 1)
-	if (i > hostdata->id_mask)
-	    hostdata->id_higher_mask |=3D i;
-    for (i =3D 0; i < 8; ++i)
-	hostdata->busy[i] =3D 0;
-#ifdef SUPPORT_TAGS
-    init_tags();
-#endif
-#if defined (REAL_DMA)
-    hostdata->dma_len =3D 0;
-#endif
-    hostdata->targets_present =3D 0;
-    hostdata->connected =3D NULL;
-    hostdata->issue_queue =3D NULL;
-    hostdata->disconnected_queue =3D NULL;
-    hostdata->flags =3D FLAG_CHECK_LAST_BYTE_SENT;
-
-    if (!the_template) {
-	the_template =3D instance->hostt;
-	first_instance =3D instance;
-    }
-
-    prepare_info(instance);
-
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-    NCR5380_write(MODE_REG, MR_BASE);
-    NCR5380_write(TARGET_COMMAND_REG, 0);
-    NCR5380_write(SELECT_ENABLE_REG, 0);
-
-    return 0;
-}
-
-static void NCR5380_exit(struct Scsi_Host *instance)
-{
-	/* Empty, as we didn't schedule any delayed work */
-}
-
-/*=20
- * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
- *	void (*done)(struct scsi_cmnd *))
- *
- * Purpose :  enqueues a SCSI command
- *
- * Inputs : cmd - SCSI command, done - function called on completion, =
with
- *	a pointer to the command descriptor.
- *=20
- * Returns : 0
- *
- * Side effects :=20
- *      cmd is added to the per instance issue_queue, with minor=20
- *	twiddling done to the host specific fields of cmd.  If the=20
- *	main coroutine is not running, it is restarted.
- *
- */
-
-/* Only make static if a wrapper function is used */
-static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
-				 void (*done)(struct scsi_cmnd *))
-{
-    SETUP_HOSTDATA(cmd->device->host);
-    struct scsi_cmnd *tmp;
-    unsigned long flags;
-
-#if (NDEBUG & NDEBUG_NO_WRITE)
-    switch (cmd->cmnd[0]) {
-    case WRITE_6:
-    case WRITE_10:
-	printk(KERN_NOTICE "scsi%d: WRITE attempted with NO_WRITE debugging f=
lag set\n",
-	       H_NO(cmd));
-	cmd->result =3D (DID_ERROR << 16);
-	done(cmd);
-	return 0;
-    }
-#endif /* (NDEBUG & NDEBUG_NO_WRITE) */
-
-    /*=20
-     * We use the host_scribble field as a pointer to the next command=
 =20
-     * in a queue=20
-     */
-
-    SET_NEXT(cmd, NULL);
-    cmd->scsi_done =3D done;
-
-    cmd->result =3D 0;
-
-
-    /*=20
-     * Insert the cmd into the issue queue. Note that REQUEST SENSE=20
-     * commands are added to the head of the queue since any command w=
ill
-     * clear the contingent allegiance condition that exists and the=20
-     * sense data is only guaranteed to be valid while the condition e=
xists.
-     */
-
-    local_irq_save(flags);
-    /* ++guenther: now that the issue queue is being set up, we can lo=
ck ST-DMA.
-     * Otherwise a running NCR5380_main may steal the lock.
-     * Lock before actually inserting due to fairness reasons explaine=
d in
-     * atari_scsi.c. If we insert first, then it's impossible for this=
 driver
-     * to release the lock.
-     * Stop timer for this command while waiting for the lock, or time=
outs
-     * may happen (and they really do), and it's no good if the comman=
d doesn't
-     * appear in any of the queues.
-     * ++roman: Just disabling the NCR interrupt isn't sufficient here=
,
-     * because also a timer int can trigger an abort or reset, which w=
ould
-     * alter queues and touch the lock.
-     */
-    if (!(hostdata->issue_queue) || (cmd->cmnd[0] =3D=3D REQUEST_SENSE=
)) {
-	LIST(cmd, hostdata->issue_queue);
-	SET_NEXT(cmd, hostdata->issue_queue);
-	hostdata->issue_queue =3D cmd;
-    } else {
-	for (tmp =3D (struct scsi_cmnd *)hostdata->issue_queue;
-	     NEXT(tmp); tmp =3D NEXT(tmp))
-	    ;
-	LIST(cmd, tmp);
-	SET_NEXT(tmp, cmd);
-    }
-
-    local_irq_restore(flags);
-
-    dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H=
_NO(cmd),
-	      (cmd->cmnd[0] =3D=3D REQUEST_SENSE) ? "head" : "tail");
-
-    /* If queue_command() is called from an interrupt (real one or bot=
tom
-     * half), we let queue_main() do the job of taking care about main=
=2E If it
-     * is already running, this is a no-op, else main will be queued.
-     *
-     * If we're not in an interrupt, we can call NCR5380_main()
-     * unconditionally, because it cannot be already running.
-     */
-    if (in_interrupt() || ((flags >> 8) & 7) >=3D 6)
-	queue_main();
-    else
-	NCR5380_main(NULL);
-    return 0;
-}
-
-static DEF_SCSI_QCMD(NCR5380_queue_command)
-
-/*
- * Function : NCR5380_main (void)=20
- *
- * Purpose : NCR5380_main is a coroutine that runs as long as more wor=
k can=20
- *	be done on the NCR5380 host adapters in a system.  Both=20
- *	NCR5380_queue_command() and NCR5380_intr() will try to start it=20
- *	in case it is not running.
- *=20
- * NOTE : NCR5380_main exits with interrupts *disabled*, the caller sh=
ould=20
- *  reenable them.  This prevents reentrancy and kernel stack overflow=
=2E
- */ =09
-   =20
-static void NCR5380_main (struct work_struct *bl)
-{
-    struct scsi_cmnd *tmp, *prev;
-    struct Scsi_Host *instance =3D first_instance;
-    struct NCR5380_hostdata *hostdata =3D HOSTDATA(instance);
-    int done;
-    unsigned long flags;
-   =20
-    /*
-     * We run (with interrupts disabled) until we're sure that none of=
=20
-     * the host adapters have anything that can be done, at which poin=
t=20
-     * we set main_running to 0 and exit.
-     *
-     * Interrupts are enabled before doing various other internal=20
-     * instructions, after we've decided that we need to run through
-     * the loop again.
-     *
-     * this should prevent any race conditions.
-     *=20
-     * ++roman: Just disabling the NCR interrupt isn't sufficient here=
,
-     * because also a timer int can trigger an abort or reset, which c=
an
-     * alter queues and touch the Falcon lock.
-     */
-
-    /* Tell int handlers main() is now already executing.  Note that
-       no races are possible here. If an int comes in before
-       'main_running' is set here, and queues/executes main via the
-       task queue, it doesn't do any harm, just this instance of main
-       won't find any work left to do. */
-    if (main_running)
-    	return;
-    main_running =3D 1;
-
-    local_save_flags(flags);
-    do {
-	local_irq_disable(); /* Freeze request queues */
-	done =3D 1;
-=09
-	if (!hostdata->connected) {
-	    dprintk(NDEBUG_MAIN,  "scsi%d: not connected\n", HOSTNO );
-	    /*
-	     * Search through the issue_queue for a command destined
-	     * for a target that's not busy.
-	     */
-#if (NDEBUG & NDEBUG_LISTS)
-	    for (tmp =3D (struct scsi_cmnd *) hostdata->issue_queue, prev =3D=
 NULL;
-		 tmp && (tmp !=3D prev); prev =3D tmp, tmp =3D NEXT(tmp))
-		;
-	    if ((tmp =3D=3D prev) && tmp) printk(" LOOP\n");/* else printk("\=
n");*/
-#endif
-	    for (tmp =3D (struct scsi_cmnd *) hostdata->issue_queue,
-		 prev =3D NULL; tmp; prev =3D tmp, tmp =3D NEXT(tmp) ) {
-
-		if (prev !=3D tmp)
-			dprintk(NDEBUG_LISTS, "MAIN tmp=3D%p   target=3D%d   busy=3D%d lun=3D=
%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->de=
vice->lun);
-		/*  When we find one, remove it from the issue queue. */
-		/* ++guenther: possible race with Falcon locking */
-		if (
-#ifdef SUPPORT_TAGS
-		    !is_lun_busy( tmp, tmp->cmnd[0] !=3D REQUEST_SENSE)
-#else
-		    !(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))
-#endif
-		    ) {
-		    /* ++guenther: just to be sure, this must be atomic */
-		    local_irq_disable();
-		    if (prev) {
-		        REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
-			SET_NEXT(prev, NEXT(tmp));
-		    } else {
-		        REMOVE(-1, hostdata->issue_queue, tmp, NEXT(tmp));
-			hostdata->issue_queue =3D NEXT(tmp);
-		    }
-		    SET_NEXT(tmp, NULL);
-		   =20
-		    /* reenable interrupts after finding one */
-		    local_irq_restore(flags);
-		   =20
-		    /*=20
-		     * Attempt to establish an I_T_L nexus here.=20
-		     * On success, instance->hostdata->connected is set.
-		     * On failure, we must add the command back to the
-		     *   issue queue so we can keep trying.=09
-		     */
-		    dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-				"lun %llu removed from issue_queue\n",
-				HOSTNO, tmp->device->id, tmp->device->lun);
-		    /*=20
-		     * REQUEST SENSE commands are issued without tagged
-		     * queueing, even on SCSI-II devices because the=20
-		     * contingent allegiance condition exists for the=20
-		     * entire unit.
-		     */
-		    /* ++roman: ...and the standard also requires that
-		     * REQUEST SENSE command are untagged.
-		     */
-		   =20
-#ifdef SUPPORT_TAGS
-		    cmd_get_tag( tmp, tmp->cmnd[0] !=3D REQUEST_SENSE );
-#endif
-		    if (!NCR5380_select(instance, tmp)) {
-			break;
-		    } else {
-			local_irq_disable();
-			LIST(tmp, hostdata->issue_queue);
-			SET_NEXT(tmp, hostdata->issue_queue);
-			hostdata->issue_queue =3D tmp;
-#ifdef SUPPORT_TAGS
-			cmd_free_tag( tmp );
-#endif
-			local_irq_restore(flags);
-			dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
-				    "returned to issue_queue\n", HOSTNO);
-			if (hostdata->connected)
-			    break;
-		    }
-		} /* if target/lun/target queue is not busy */
-	    } /* for issue_queue */
-	} /* if (!hostdata->connected) */
-	if (hostdata->connected=20
-#ifdef REAL_DMA
-	    && !hostdata->dma_len
-#endif
-	    ) {
-	    local_irq_restore(flags);
-	    dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transf=
er\n",
-			HOSTNO);
-	    NCR5380_information_transfer(instance);
-	    dprintk(NDEBUG_MAIN, "scsi%d: main: done set false\n", HOSTNO);
-	    done =3D 0;
-	}
-    } while (!done);
-
-    /* Better allow ints _after_ 'main_running' has been cleared, else
-       an interrupt could believe we'll pick up the work it left for
-       us, but we won't see it anymore here... */
-    main_running =3D 0;
-    local_irq_restore(flags);
-}
-
-
-#ifdef REAL_DMA
-/*
- * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
- *
- * Purpose : Called by interrupt handler when DMA finishes or a phase
- *	mismatch occurs (which would finish the DMA transfer). =20
- *
- * Inputs : instance - this instance of the NCR5380.
- *
- */
-
-static void NCR5380_dma_complete( struct Scsi_Host *instance )
-{
-    SETUP_HOSTDATA(instance);
-    int           transfered;
-    unsigned char **data;
-    volatile int  *count;
-
-    if (!hostdata->connected) {
-	printk(KERN_WARNING "scsi%d: received end of DMA interrupt with "
-	       "no connected cmd\n", HOSTNO);
-	return;
-    }
-
-    dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X=
, sr 0x%X\n",
-	       HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
-	       NCR5380_read(STATUS_REG));
-
-    if((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request))=
)) {
-	    printk("scsi%d: overrun in UDC counter -- not prepared to deal wi=
th this!\n", HOSTNO);
-	    printk("please e-mail sammy@sammy.net with a description of how t=
his\n");
-	    printk("error was produced.\n");
-	    BUG();
-    }
-
-    /* make sure we're not stuck in a data phase */
-    if((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH |
-					    BASR_ACK)) =3D=3D
-       (BASR_PHASE_MATCH | BASR_ACK)) {
-	    printk("scsi%d: BASR %02x\n", HOSTNO, NCR5380_read(BUS_AND_STATUS=
_REG));
-	    printk("scsi%d: bus stuck in data phase -- probably a single byte=
 "
-		   "overrun!\n", HOSTNO);
-	    printk("not prepared for this error!\n");
-	    printk("please e-mail sammy@sammy.net with a description of how t=
his\n");
-	    printk("error was produced.\n");
-	    BUG();
-    }
-
-
-
-    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-    NCR5380_write(MODE_REG, MR_BASE);
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-    transfered =3D hostdata->dma_len - NCR5380_dma_residual(instance);
-    hostdata->dma_len =3D 0;
-
-    data =3D (unsigned char **) &(hostdata->connected->SCp.ptr);
-    count =3D &(hostdata->connected->SCp.this_residual);
-    *data +=3D transfered;
-    *count -=3D transfered;
-
-}
-#endif /* REAL_DMA */
-
-
-/*
- * Function : void NCR5380_intr (int irq)
- *=20
- * Purpose : handle interrupts, reestablishing I_T_L or I_T_L_Q nexuse=
s
- *	from the disconnected queue, and restarting NCR5380_main()=20
- *	as required.
- *
- * Inputs : int irq, irq that caused this interrupt.
- *
- */
-
-static irqreturn_t NCR5380_intr (int irq, void *dev_id)
-{
-    struct Scsi_Host *instance =3D first_instance;
-    int done =3D 1, handled =3D 0;
-    unsigned char basr;
-
-    dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
-
-    /* Look for pending interrupts */
-    basr =3D NCR5380_read(BUS_AND_STATUS_REG);
-    dprintk(NDEBUG_INTR, "scsi%d: BASR=3D%02x\n", HOSTNO, basr);
-    /* dispatch to appropriate routine if found and done=3D0 */
-    if (basr & BASR_IRQ) {
-	NCR5380_dprint(NDEBUG_INTR, instance);
-	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) =3D=3D (SR_SEL|SR_IO)=
) {
-	    done =3D 0;
-	    dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
-	    NCR5380_reselect(instance);
-	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	}
-	else if (basr & BASR_PARITY_ERROR) {
-	    dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
-	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	}
-	else if ((NCR5380_read(STATUS_REG) & SR_RST) =3D=3D SR_RST) {
-	    dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
-	    (void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	}
-	else {
-	    /* =20
-	     * The rest of the interrupt conditions can occur only during a
-	     * DMA transfer
-	     */
-
-#if defined(REAL_DMA)
-	    /*
-	     * We should only get PHASE MISMATCH and EOP interrupts if we hav=
e
-	     * DMA enabled, so do a sanity check based on the current setting
-	     * of the MODE register.
-	     */
-
-	    if ((NCR5380_read(MODE_REG) & MR_DMA_MODE) &&
-		((basr & BASR_END_DMA_TRANSFER) ||=20
-		 !(basr & BASR_PHASE_MATCH))) {
-		   =20
-		dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO=
);
-		NCR5380_dma_complete( instance );
-		done =3D 0;
-	    } else
-#endif /* REAL_DMA */
-	    {
-/* MS: Ignore unknown phase mismatch interrupts (caused by EOP interru=
pt) */
-		if (basr & BASR_PHASE_MATCH)
-		   dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
-			   "BASR 0x%x, MR 0x%x, SR 0x%x\n",
-			   HOSTNO, basr, NCR5380_read(MODE_REG),
-			   NCR5380_read(STATUS_REG));
-		(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-#ifdef SUN3_SCSI_VME
-		dregs->csr |=3D CSR_DMA_ENABLE;
-#endif
-	    }
-	} /* if !(SELECTION || PARITY) */
-	handled =3D 1;
-    } /* BASR & IRQ */
-    else {
-
-	printk(KERN_NOTICE "scsi%d: interrupt without IRQ bit set in BASR, "
-	       "BASR 0x%X, MR 0x%X, SR 0x%x\n", HOSTNO, basr,
-	       NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
-	(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-#ifdef SUN3_SCSI_VME
-		dregs->csr |=3D CSR_DMA_ENABLE;
-#endif
-    }
-   =20
-    if (!done) {
-	dprintk(NDEBUG_INTR, "scsi%d: in int routine, calling main\n", HOSTNO=
);
-	/* Put a call to NCR5380_main() on the queue... */
-	queue_main();
-    }
-    return IRQ_RETVAL(handled);
-}
-
-/*=20
- * Function : int NCR5380_select(struct Scsi_Host *instance,
- *				 struct scsi_cmnd *cmd)
- *
- * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing co=
mmand,
- *	including ARBITRATION, SELECTION, and initial message out for=20
- *	IDENTIFY and queue messages.=20
- *
- * Inputs : instance - instantiation of the 5380 driver on which this=20
- *	target lives, cmd - SCSI command to execute.
- *=20
- * Returns : -1 if selection could not execute for some reason,
- *	0 if selection succeeded or failed because the target=20
- * 	did not respond.
- *
- * Side effects :=20
- * 	If bus busy, arbitration failed, etc, NCR5380_select() will exit=20
- *		with registers as they should have been on entry - ie
- *		SELECT_ENABLE will be set appropriately, the NCR5380
- *		will cease to drive any SCSI bus signals.
- *
- *	If successful : I_T_L or I_T_L_Q nexus will be established,=20
- *		instance->connected will be set to cmd. =20
- * 		SELECT interrupt will be disabled.
- *
- *	If failed (no target) : cmd->scsi_done() will be called, and the=20
- *		cmd->result host byte set to DID_BAD_TARGET.
- */
-
-static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd=
 *cmd)
-{
-    SETUP_HOSTDATA(instance);
-    unsigned char tmp[3], phase;
-    unsigned char *data;
-    int len;
-    unsigned long timeout;
-    unsigned long flags;
-
-    hostdata->restart_select =3D 0;
-    NCR5380_dprint(NDEBUG_ARBITRATION, instance);
-    dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id =3D =
%d\n", HOSTNO,
-	       instance->this_id);
-
-    /*=20
-     * Set the phase bits to 0, otherwise the NCR5380 won't drive the=20
-     * data bus during SELECTION.
-     */
-
-    local_irq_save(flags);
-    if (hostdata->connected) {
-	local_irq_restore(flags);
-	return -1;
-    }
-    NCR5380_write(TARGET_COMMAND_REG, 0);
-
-
-    /*=20
-     * Start arbitration.
-     */
-   =20
-    NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
-    NCR5380_write(MODE_REG, MR_ARBITRATE);
-
-    local_irq_restore(flags);
-
-    /* Wait for arbitration logic to complete */
-#ifdef NCR_TIMEOUT
-    {
-      unsigned long timeout =3D jiffies + 2*NCR_TIMEOUT;
-
-      while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_P=
ROGRESS)
-	   && time_before(jiffies, timeout) && !hostdata->connected)
-	;
-      if (time_after_eq(jiffies, timeout))
-      {
-	printk("scsi : arbitration timeout at %d\n", __LINE__);
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	return -1;
-      }
-    }
-#else /* NCR_TIMEOUT */
-    while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PRO=
GRESS)
-	 && !hostdata->connected);
-#endif
-
-    dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOST=
NO);
-
-    if (hostdata->connected) {
-	NCR5380_write(MODE_REG, MR_BASE);=20
-	return -1;
-    }
-    /*=20
-     * The arbitration delay is 2.2us, but this is a minimum and there=
 is=20
-     * no maximum so we can safely sleep for ceil(2.2) usecs to accomm=
odate
-     * the integral nature of udelay().
-     *
-     */
-
-    udelay(3);
-
-    /* Check for lost arbitration */
-    if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) |=
|
-	(NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
-	(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	hostdata->connected) {
-	NCR5380_write(MODE_REG, MR_BASE);=20
-	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR=
_ARBITRATE\n",
-		   HOSTNO);
-	return -1;
-    }
-
-     /* after/during arbitration, BSY should be asserted.
-	IBM DPES-31080 Version S31Q works now */
-     /* Tnx to Thomas_Roesch@m2.maus.de for finding this! (Roman) */
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_SEL |
-					 ICR_ASSERT_BSY ) ;
-   =20
-    if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) |=
|
-	hostdata->connected) {
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting IC=
R_ASSERT_SEL\n",
-		   HOSTNO);
-	return -1;
-    }
-
-    /*=20
-     * Again, bus clear + bus settle time is 1.2us, however, this is=20
-     * a minimum so we'll udelay ceil(1.2)
-     */
-
-#ifdef CONFIG_ATARI_SCSI_TOSHIBA_DELAY
-    /* ++roman: But some targets (see above :-) seem to need a bit mor=
e... */
-    udelay(15);
-#else
-    udelay(2);
-#endif
-   =20
-    if (hostdata->connected) {
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	return -1;
-    }
-
-    dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
-
-    /*=20
-     * Now that we have won arbitration, start Selection process, asse=
rting=20
-     * the host and target ID's on the SCSI bus.
-     */
-
-    NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << cmd->dev=
ice->id)));
-
-    /*=20
-     * Raise ATN while SEL is true before BSY goes false from arbitrat=
ion,
-     * since this is the only way to guarantee that we'll get a MESSAG=
E OUT
-     * phase immediately after selection.
-     */
-
-    NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_BSY |=20
-	ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL ));
-    NCR5380_write(MODE_REG, MR_BASE);
-
-    /*=20
-     * Reselect interrupts must be turned off prior to the dropping of=
 BSY,
-     * otherwise we will trigger an interrupt.
-     */
-
-    if (hostdata->connected) {
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	return -1;
-    }
-
-    NCR5380_write(SELECT_ENABLE_REG, 0);
-
-    /*
-     * The initiator shall then wait at least two deskew delays and re=
lease=20
-     * the BSY signal.
-     */
-    udelay(1);        /* wingel -- wait two bus deskew delay >2*45ns *=
/
-
-    /* Reset BSY */
-    NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA |=
=20
-	ICR_ASSERT_ATN | ICR_ASSERT_SEL));
-
-    /*=20
-     * Something weird happens when we cease to drive BSY - looks
-     * like the board/chip is letting us do another read before the=20
-     * appropriate propagation delay has expired, and we're confusing
-     * a BSY signal from ourselves as the target's response to SELECTI=
ON.
-     *
-     * A small delay (the 'C++' frontend breaks the pipeline with an
-     * unnecessary jump, making it work on my 386-33/Trantor T128, the
-     * tighter 'C' code breaks and requires this) solves the problem -=
=20
-     * the 1 us delay is arbitrary, and only used because this delay w=
ill=20
-     * be the same on other platforms and since it works here, it shou=
ld=20
-     * work there.
-     *
-     * wingel suggests that this could be due to failing to wait
-     * one deskew delay.
-     */
-
-    udelay(1);
-
-    dprintk(NDEBUG_SELECTION, "scsi%d: selecting target %d\n", HOSTNO,=
 cmd->device->id);
-
-    /*=20
-     * The SCSI specification calls for a 250 ms timeout for the actua=
l=20
-     * selection.
-     */
-
-    timeout =3D jiffies + 25;=20
-
-    /*=20
-     * XXX very interesting - we're seeing a bounce where the BSY we=20
-     * asserted is being reflected / still asserted (propagation delay=
?)
-     * and it's detecting as true.  Sigh.
-     */
-
-#if 0
-    /* ++roman: If a target conformed to the SCSI standard, it wouldn'=
t assert
-     * IO while SEL is true. But again, there are some disks out the i=
n the
-     * world that do that nevertheless. (Somebody claimed that this an=
nounces
-     * reselection capability of the target.) So we better skip that t=
est and
-     * only wait for BSY... (Famous german words: Der Kl=C3=BCgere gib=
t nach :-)
-     */
-
-    while (time_before(jiffies, timeout) && !(NCR5380_read(STATUS_REG)=
 &=20
-	(SR_BSY | SR_IO)));
-
-    if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) =3D=3D=20
-	    (SR_SEL | SR_IO)) {
-	    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	    NCR5380_reselect(instance);
-	    printk (KERN_ERR "scsi%d: reselection after won arbitration?\n",
-		    HOSTNO);
-	    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	    return -1;
-    }
-#else
-    while (time_before(jiffies, timeout) && !(NCR5380_read(STATUS_REG)=
 & SR_BSY));
-#endif
-
-    /*=20
-     * No less than two deskew delays after the initiator detects the=20
-     * BSY signal is true, it shall release the SEL signal and may=20
-     * change the DATA BUS.                                     -winge=
l
-     */
-
-    udelay(1);
-
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-
-    if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	if (hostdata->targets_present & (1 << cmd->device->id)) {
-	    printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
-	    if (hostdata->restart_select)
-		printk(KERN_NOTICE "\trestart select\n");
-	    NCR5380_dprint(NDEBUG_ANY, instance);
-	    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	    return -1;
-	}
-	cmd->result =3D DID_BAD_TARGET << 16;
-#ifdef SUPPORT_TAGS
-	cmd_free_tag( cmd );
-#endif
-	cmd->scsi_done(cmd);
-	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250m=
s\n", HOSTNO);
-	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	return 0;
-    }=20
-
-    hostdata->targets_present |=3D (1 << cmd->device->id);
-
-    /*
-     * Since we followed the SCSI spec, and raised ATN while SEL=20
-     * was true but before BSY was false during selection, the informa=
tion
-     * transfer phase should be a MESSAGE OUT phase so that we can sen=
d the
-     * IDENTIFY message.
-     *=20
-     * If SCSI-II tagged queuing is enabled, we also send a SIMPLE_QUE=
UE_TAG
-     * message (2 bytes) with a tag ID that we increment with every co=
mmand
-     * until it wraps back to 0.
-     *
-     * XXX - it turns out that there are some broken SCSI-II devices,
-     *	     which claim to support tagged queuing but fail when more t=
han
-     *	     some number of commands are issued at once.
-     */
-
-    /* Wait for start of REQ/ACK handshake */
-    while (!(NCR5380_read(STATUS_REG) & SR_REQ));
-
-    dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into =
MESSAGE OUT phase.\n",
-	       HOSTNO, cmd->device->id);
-    tmp[0] =3D IDENTIFY(1, cmd->device->lun);
-
-#ifdef SUPPORT_TAGS
-    if (cmd->tag !=3D TAG_NONE) {
-	tmp[1] =3D hostdata->last_message =3D SIMPLE_QUEUE_TAG;
-	tmp[2] =3D cmd->tag;
-	len =3D 3;
-    } else=20
-	len =3D 1;
-#else
-    len =3D 1;
-    cmd->tag=3D0;
-#endif /* SUPPORT_TAGS */
-
-    /* Send message(s) */
-    data =3D tmp;
-    phase =3D PHASE_MSGOUT;
-    NCR5380_transfer_pio(instance, &phase, &len, &data);
-    dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
-    /* XXX need to handle errors here */
-    hostdata->connected =3D cmd;
-#ifndef SUPPORT_TAGS
-    hostdata->busy[cmd->device->id] |=3D (1 << cmd->device->lun);
-#endif   =20
-#ifdef SUN3_SCSI_VME
-    dregs->csr |=3D CSR_INTR;
-#endif
-    initialize_SCp(cmd);
-
-
-    return 0;
-}
-
-/*=20
- * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,=20
- *      unsigned char *phase, int *count, unsigned char **data)
- *
- * Purpose : transfers data in given phase using polled I/O
- *
- * Inputs : instance - instance of driver, *phase - pointer to=20
- *	what phase is expected, *count - pointer to number of=20
- *	bytes to transfer, **data - pointer to data pointer.
- *=20
- * Returns : -1 when different phase is entered without transferring
- *	maximum number of bytes, 0 if all bytes are transferred or exit
- *	is in same phase.
- *
- * 	Also, *phase, *count, *data are modified in place.
- *
- * XXX Note : handling for bus free may be useful.
- */
-
-/*
- * Note : this code is not as quick as it could be, however it=20
- * IS 100% reliable, and for the actual data transfer where speed
- * counts, we will always do a pseudo DMA or DMA transfer.
- */
-
-static int NCR5380_transfer_pio( struct Scsi_Host *instance,=20
-				 unsigned char *phase, int *count,
-				 unsigned char **data)
-{
-    register unsigned char p =3D *phase, tmp;
-    register int c =3D *count;
-    register unsigned char *d =3D *data;
-
-    /*=20
-     * The NCR5380 chip will only drive the SCSI bus when the=20
-     * phase specified in the appropriate bits of the TARGET COMMAND
-     * REGISTER match the STATUS REGISTER
-     */
-
-    NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
-
-    do {
-	/*=20
-	 * Wait for assertion of REQ, after which the phase bits will be=20
-	 * valid=20
-	 */
-	while (!((tmp =3D NCR5380_read(STATUS_REG)) & SR_REQ));
-
-	dprintk(NDEBUG_HANDSHAKE, "scsi%d: REQ detected\n", HOSTNO);
-
-	/* Check for phase mismatch */=09
-	if ((tmp & PHASE_MASK) !=3D p) {
-	    dprintk(NDEBUG_PIO, "scsi%d: phase mismatch\n", HOSTNO);
-	    NCR5380_dprint_phase(NDEBUG_PIO, instance);
-	    break;
-	}
-
-	/* Do actual transfer from SCSI bus to / from memory */
-	if (!(p & SR_IO))=20
-	    NCR5380_write(OUTPUT_DATA_REG, *d);
-	else=20
-	    *d =3D NCR5380_read(CURRENT_SCSI_DATA_REG);
-
-	++d;
-
-	/*=20
-	 * The SCSI standard suggests that in MSGOUT phase, the initiator
-	 * should drop ATN on the last byte of the message phase
-	 * after REQ has been asserted for the handshake but before
-	 * the initiator raises ACK.
-	 */
-
-	if (!(p & SR_IO)) {
-	    if (!((p & SR_MSG) && c > 1)) {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-		    ICR_ASSERT_DATA);
-		NCR5380_dprint(NDEBUG_PIO, instance);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-			ICR_ASSERT_DATA | ICR_ASSERT_ACK);
-	    } else {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-		    ICR_ASSERT_DATA | ICR_ASSERT_ATN);
-		NCR5380_dprint(NDEBUG_PIO, instance);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-		    ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-	    }
-	} else {
-	    NCR5380_dprint(NDEBUG_PIO, instance);
-	    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
-	}
-
-	while (NCR5380_read(STATUS_REG) & SR_REQ);
-
-	dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", =
HOSTNO);
-
-/*
- * We have several special cases to consider during REQ/ACK handshakin=
g :=20
- * 1.  We were in MSGOUT phase, and we are on the last byte of the=20
- *	message.  ATN must be dropped as ACK is dropped.
- *
- * 2.  We are in a MSGIN phase, and we are on the last byte of the =20
- *	message.  We must exit with ACK asserted, so that the calling
- *	code may raise ATN before dropping ACK to reject the message.
- *
- * 3.  ACK and ATN are clear and the target may proceed as normal.
- */
-	if (!(p =3D=3D PHASE_MSGIN && c =3D=3D 1)) { =20
-	    if (p =3D=3D PHASE_MSGOUT && c > 1)
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-	    else
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	}=20
-    } while (--c);
-
-    dprintk(NDEBUG_PIO, "scsi%d: residual %d\n", HOSTNO, c);
-
-    *count =3D c;
-    *data =3D d;
-    tmp =3D NCR5380_read(STATUS_REG);
-    /* The phase read from the bus is valid if either REQ is (already)
-     * asserted or if ACK hasn't been released yet. The latter is the =
case if
-     * we're in MSGIN and all wanted bytes have been received. */
-    if ((tmp & SR_REQ) || (p =3D=3D PHASE_MSGIN && c =3D=3D 0))
-	*phase =3D tmp & PHASE_MASK;
-    else=20
-	*phase =3D PHASE_UNKNOWN;
-
-    if (!c || (*phase =3D=3D p))
-	return 0;
-    else=20
-	return -1;
-}
-
-/*
- * Function : do_abort (Scsi_Host *host)
- *=20
- * Purpose : abort the currently established nexus.  Should only be=20
- * 	called from a routine which can drop into a=20
- *=20
- * Returns : 0 on success, -1 on failure.
- */
-
-static int do_abort (struct Scsi_Host *host)=20
-{
-    unsigned char tmp, *msgptr, phase;
-    int len;
-
-    /* Request message out phase */
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-
-    /*=20
-     * Wait for the target to indicate a valid phase by asserting=20
-     * REQ.  Once this happens, we'll have either a MSGOUT phase=20
-     * and can immediately send the ABORT message, or we'll have some=20
-     * other phase and will have to source/sink data.
-     *=20
-     * We really don't care what value was on the bus or what value
-     * the target sees, so we just handshake.
-     */
-   =20
-    while (!((tmp =3D NCR5380_read(STATUS_REG)) & SR_REQ));
-
-    NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
-
-    if ((tmp & PHASE_MASK) !=3D PHASE_MSGOUT) {
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN |=20
-		      ICR_ASSERT_ACK);
-	while (NCR5380_read(STATUS_REG) & SR_REQ);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-    }
-  =20
-    tmp =3D ABORT;
-    msgptr =3D &tmp;
-    len =3D 1;
-    phase =3D PHASE_MSGOUT;
-    NCR5380_transfer_pio (host, &phase, &len, &msgptr);
-
-    /*
-     * If we got here, and the command completed successfully,
-     * we're about to go into bus free state.
-     */
-
-    return len ? -1 : 0;
-}
-
-#if defined(REAL_DMA)
-/*=20
- * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,=20
- *      unsigned char *phase, int *count, unsigned char **data)
- *
- * Purpose : transfers data in given phase using either real
- *	or pseudo DMA.
- *
- * Inputs : instance - instance of driver, *phase - pointer to=20
- *	what phase is expected, *count - pointer to number of=20
- *	bytes to transfer, **data - pointer to data pointer.
- *=20
- * Returns : -1 when different phase is entered without transferring
- *	maximum number of bytes, 0 if all bytes or transferred or exit
- *	is in same phase.
- *
- * 	Also, *phase, *count, *data are modified in place.
- *
- */
-
-
-static int NCR5380_transfer_dma( struct Scsi_Host *instance,=20
-				 unsigned char *phase, int *count,
-				 unsigned char **data)
-{
-    SETUP_HOSTDATA(instance);
-    register int c =3D *count;
-    register unsigned char p =3D *phase;
-    unsigned long flags;
-
-    /* sanity check */
-    if(!sun3_dma_setup_done) {
-	 printk("scsi%d: transfer_dma without setup!\n", HOSTNO);
-	 BUG();
-    }
-    hostdata->dma_len =3D c;
-
-    dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s =
%p\n",
-	       HOSTNO, (p & SR_IO) ? "reading" : "writing",
-	       c, (p & SR_IO) ? "to" : "from", *data);
-
-    /* netbsd turns off ints here, why not be safe and do it too */
-    local_irq_save(flags);
-   =20
-    /* send start chain */
-    sun3scsi_dma_start(c, *data);
-   =20
-    if (p & SR_IO) {
-	    NCR5380_write(TARGET_COMMAND_REG, 1);
-	    NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	    NCR5380_write(INITIATOR_COMMAND_REG, 0);
-	    NCR5380_write(MODE_REG, (NCR5380_read(MODE_REG) | MR_DMA_MODE | M=
R_ENABLE_EOP_INTR));
-	    NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
-    } else {
-	    NCR5380_write(TARGET_COMMAND_REG, 0);
-	    NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	    NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_DATA);
-	    NCR5380_write(MODE_REG, (NCR5380_read(MODE_REG) | MR_DMA_MODE | M=
R_ENABLE_EOP_INTR));
-	    NCR5380_write(START_DMA_SEND_REG, 0);
-    }
-
-#ifdef SUN3_SCSI_VME
-    dregs->csr |=3D CSR_DMA_ENABLE;
-#endif
-
-    local_irq_restore(flags);
-
-    sun3_dma_active =3D 1;
-    return 0;
-}
-#endif /* defined(REAL_DMA) */
-
-/*
- * Function : NCR5380_information_transfer (struct Scsi_Host *instance=
)
- *
- * Purpose : run through the various SCSI phases and do as the target=20
- * 	directs us to.  Operates on the currently connected command,=20
- *	instance->connected.
- *
- * Inputs : instance, instance for which we are doing commands
- *
- * Side effects : SCSI things happen, the disconnected queue will be=20
- *	modified if a command disconnects, *instance->connected will
- *	change.
- *
- * XXX Note : we need to watch for bus free or a reset condition here=20
- * 	to recover from an unexpected bus free condition.
- */
-=20
-static void NCR5380_information_transfer (struct Scsi_Host *instance)
-{
-    SETUP_HOSTDATA(instance);
-    unsigned long flags;
-    unsigned char msgout =3D NOP;
-    int sink =3D 0;
-    int len;
-#if defined(REAL_DMA)
-    int transfersize;
-#endif
-    unsigned char *data;
-    unsigned char phase, tmp, extended_msg[10], old_phase=3D0xff;
-    struct scsi_cmnd *cmd =3D (struct scsi_cmnd *) hostdata->connected=
;
-
-#ifdef SUN3_SCSI_VME
-    dregs->csr |=3D CSR_INTR;
-#endif
-
-    while (1) {
-	tmp =3D NCR5380_read(STATUS_REG);
-	/* We only have a valid SCSI phase when REQ is asserted */
-	if (tmp & SR_REQ) {
-	    phase =3D (tmp & PHASE_MASK);=20
- 	    if (phase !=3D old_phase) {
-		old_phase =3D phase;
-		NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
-	    }
-
-	    if(phase =3D=3D PHASE_CMDOUT) {
-		    void *d;
-		    unsigned long count;
-
-		if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
-			count =3D cmd->SCp.buffer->length;
-			d =3D SGADDR(cmd->SCp.buffer);
-		} else {
-			count =3D cmd->SCp.this_residual;
-			d =3D cmd->SCp.ptr;
-		}
-#ifdef REAL_DMA
-		/* this command setup for dma yet? */
-		if((count > SUN3_DMA_MINSIZE) && (sun3_dma_setup_done
-						  !=3D cmd))
-		{
-			if (cmd->request->cmd_type =3D=3D REQ_TYPE_FS) {
-				sun3scsi_dma_setup(d, count,
-						   rq_data_dir(cmd->request));
-				sun3_dma_setup_done =3D cmd;
-			}
-		}
-#endif
-#ifdef SUN3_SCSI_VME
-		dregs->csr |=3D CSR_INTR;
-#endif
-	    }
-
-	   =20
-	    if (sink && (phase !=3D PHASE_MSGOUT)) {
-		NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
-
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN |=20
-		    ICR_ASSERT_ACK);
-		while (NCR5380_read(STATUS_REG) & SR_REQ);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-		    ICR_ASSERT_ATN);
-		sink =3D 0;
-		continue;
-	    }
-
-	    switch (phase) {
-	    case PHASE_DATAOUT:
-#if (NDEBUG & NDEBUG_NO_DATAOUT)
-		printk("scsi%d: NDEBUG_NO_DATAOUT set, attempted DATAOUT "
-		       "aborted\n", HOSTNO);
-		sink =3D 1;
-		do_abort(instance);
-		cmd->result =3D DID_ERROR  << 16;
-		cmd->scsi_done(cmd);
-		return;
-#endif
-	    case PHASE_DATAIN:
-		/*=20
-		 * If there is no room left in the current buffer in the
-		 * scatter-gather list, move onto the next one.
-		 */
-		if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
-		    ++cmd->SCp.buffer;
-		    --cmd->SCp.buffers_residual;
-		    cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
-		    cmd->SCp.ptr =3D SGADDR(cmd->SCp.buffer);
-		    dprintk(NDEBUG_INFORMATION, "scsi%d: %d bytes and %d buffers lef=
t\n",
-			       HOSTNO, cmd->SCp.this_residual,
-			       cmd->SCp.buffers_residual);
-		}
-
-		/*
-		 * The preferred transfer method is going to be=20
-		 * PSEUDO-DMA for systems that are strictly PIO,
-		 * since we can let the hardware do the handshaking.
-		 *
-		 * For this to work, we need to know the transfersize
-		 * ahead of time, since the pseudo-DMA code will sit
-		 * in an unconditional loop.
-		 */
-
-/* ++roman: I suggest, this should be
- *   #if def(REAL_DMA)
- * instead of leaving REAL_DMA out.
- */
-
-#if defined(REAL_DMA)
-//		if (!cmd->device->borken &&
-		if((transfersize =3D
-		    NCR5380_dma_xfer_len(instance,cmd,phase)) > SUN3_DMA_MINSIZE) {
-		    len =3D transfersize;
-		    cmd->SCp.phase =3D phase;
-
-		    if (NCR5380_transfer_dma(instance, &phase,
-			&len, (unsigned char **) &cmd->SCp.ptr)) {
-			/*
-			 * If the watchdog timer fires, all future
-			 * accesses to this device will use the
-			 * polled-IO. */=20
-			printk(KERN_NOTICE "scsi%d: switching target %d "
-			       "lun %llu to slow handshake\n", HOSTNO,
-			       cmd->device->id, cmd->device->lun);
-			cmd->device->borken =3D 1;
-			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-			    ICR_ASSERT_ATN);
-			sink =3D 1;
-			do_abort(instance);
-			cmd->result =3D DID_ERROR  << 16;
-			cmd->scsi_done(cmd);
-			/* XXX - need to source or sink data here, as appropriate */
-		    } else {
-#ifdef REAL_DMA
-			/* ++roman: When using real DMA,
-			 * information_transfer() should return after
-			 * starting DMA since it has nothing more to
-			 * do.
-			 */
-				    return;
-#else		=09
-			cmd->SCp.this_residual -=3D transfersize - len;
-#endif
-		    }
-		} else=20
-#endif /* defined(REAL_DMA) */
-		  NCR5380_transfer_pio(instance, &phase,=20
-		    (int *) &cmd->SCp.this_residual, (unsigned char **)
-		    &cmd->SCp.ptr);
-#ifdef REAL_DMA
-		/* if we had intended to dma that command clear it */
-		if(sun3_dma_setup_done =3D=3D cmd)
-			sun3_dma_setup_done =3D NULL;
-#endif
-
-		break;
-	    case PHASE_MSGIN:
-		len =3D 1;
-		data =3D &tmp;
-		NCR5380_write(SELECT_ENABLE_REG, 0); 	/* disable reselects */
-		NCR5380_transfer_pio(instance, &phase, &len, &data);
-		cmd->SCp.Message =3D tmp;
-	=09
-		switch (tmp) {
-		/*
-		 * Linking lets us reduce the time required to get the=20
-		 * next command out to the device, hopefully this will
-		 * mean we don't waste another revolution due to the delays
-		 * required by ARBITRATION and another SELECTION.
-		 *
-		 * In the current implementation proposal, low level drivers
-		 * merely have to start the next command, pointed to by=20
-		 * next_link, done() is called as with unlinked commands.
-		 */
-#ifdef LINKED
-		case LINKED_CMD_COMPLETE:
-		case LINKED_FLG_CMD_COMPLETE:
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		   =20
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked comman=
d "
-			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
-
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    /*
-		     * Sanity check : A linked command should only terminate
-		     * with one of these messages if there are more linked
-		     * commands available.
-		     */
-
-		    if (!cmd->next_link) {
-			 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
-				"linked command complete, no next_link\n",
-				HOSTNO, cmd->device->id, cmd->device->lun);
-			    sink =3D 1;
-			    do_abort (instance);
-			    return;
-		    }
-
-		    initialize_SCp(cmd->next_link);
-		    /* The next command is still part of this process; copy it
-		     * and don't free it! */
-		    cmd->next_link->tag =3D cmd->tag;
-		    cmd->result =3D cmd->SCp.Status | (cmd->SCp.Message << 8);=20
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked reques=
t "
-			       "done, calling scsi_done().\n",
-			       HOSTNO, cmd->device->id, cmd->device->lun);
-		    cmd->scsi_done(cmd);
-		    cmd =3D hostdata->connected;
-		    break;
-#endif /* def LINKED */
-		case ABORT:
-		case COMMAND_COMPLETE:=20
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		    hostdata->connected =3D NULL;
-		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu =
"
-			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
-#ifdef SUPPORT_TAGS
-		    cmd_free_tag( cmd );
-		    if (status_byte(cmd->SCp.Status) =3D=3D QUEUE_FULL) {
-			/* Turn a QUEUE FULL status into BUSY, I think the
-			 * mid level cannot handle QUEUE FULL :-( (The
-			 * command is retried after BUSY). Also update our
-			 * queue size to the number of currently issued
-			 * commands now.
-			 */
-			/* ++Andreas: the mid level code knows about
-			   QUEUE_FULL now. */
-			TAG_ALLOC *ta =3D &TagAlloc[cmd->device->id][cmd->device->lun];
-			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu returned "
-				   "QUEUE_FULL after %d commands\n",
-				   HOSTNO, cmd->device->id, cmd->device->lun,
-				   ta->nr_allocated);
-			if (ta->queue_size > ta->nr_allocated)
-			    ta->nr_allocated =3D ta->queue_size;
-		    }
-#else
-		    hostdata->busy[cmd->device->id] &=3D ~(1 << cmd->device->lun);
-#endif
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-
-		    /*=20
-		     * I'm not sure what the correct thing to do here is :=20
-		     *=20
-		     * If the command that just executed is NOT a request=20
-		     * sense, the obvious thing to do is to set the result
-		     * code to the values of the stored parameters.
-		     *=20
-		     * If it was a REQUEST SENSE command, we need some way to
-		     * differentiate between the failure code of the original
-		     * and the failure code of the REQUEST sense - the obvious
-		     * case is success, where we fall through and leave the
-		     * result code unchanged.
-		     *=20
-		     * The non-obvious place is where the REQUEST SENSE failed
-		     */
-
-		    if (cmd->cmnd[0] !=3D REQUEST_SENSE)=20
-			cmd->result =3D cmd->SCp.Status | (cmd->SCp.Message << 8);=20
-		    else if (status_byte(cmd->SCp.Status) !=3D GOOD)
-			cmd->result =3D (cmd->result & 0x00ffff) | (DID_ERROR << 16);
-		   =20
-		    if ((cmd->cmnd[0] =3D=3D REQUEST_SENSE) &&
-			                        hostdata->ses.cmd_len) {
-			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-			hostdata->ses.cmd_len =3D 0 ;
-		    }
-
-		    if ((cmd->cmnd[0] !=3D REQUEST_SENSE) &&=20
-			(status_byte(cmd->SCp.Status) =3D=3D CHECK_CONDITION)) {
-			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
-			dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n",
-				    HOSTNO);
-			/* this is initialized from initialize_SCp=20
-			cmd->SCp.buffer =3D NULL;
-			cmd->SCp.buffers_residual =3D 0;
-			*/
-
-			local_irq_save(flags);
-			LIST(cmd,hostdata->issue_queue);
-			SET_NEXT(cmd, hostdata->issue_queue);
-		        hostdata->issue_queue =3D (struct scsi_cmnd *) cmd;
-		        local_irq_restore(flags);
-			dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
-				  "issue queue\n", H_NO(cmd));
-		   } else {
-		       cmd->scsi_done(cmd);
-		    }
-
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    /*=20
-		     * Restore phase bits to 0 so an interrupted selection,=20
-		     * arbitration can resume.
-		     */
-		    NCR5380_write(TARGET_COMMAND_REG, 0);
-		   =20
-		    while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connect=
ed)
-			barrier();
-
-		    return;
-		case MESSAGE_REJECT:
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    switch (hostdata->last_message) {
-		    case HEAD_OF_QUEUE_TAG:
-		    case ORDERED_QUEUE_TAG:
-		    case SIMPLE_QUEUE_TAG:
-			/* The target obviously doesn't support tagged
-			 * queuing, even though it announced this ability in
-			 * its INQUIRY data ?!? (maybe only this LUN?) Ok,
-			 * clear 'tagged_supported' and lock the LUN, since
-			 * the command is treated as untagged further on.
-			 */
-			cmd->device->tagged_supported =3D 0;
-			hostdata->busy[cmd->device->id] |=3D (1 << cmd->device->lun);
-			cmd->tag =3D TAG_NONE;
-			dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %llu rejected "
-				   "QUEUE_TAG message; tagged queuing "
-				   "disabled\n",
-				   HOSTNO, cmd->device->id, cmd->device->lun);
-			break;
-		    }
-		    break;
-		case DISCONNECT:
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		    local_irq_save(flags);
-		    cmd->device->disconnect =3D 1;
-		    LIST(cmd,hostdata->disconnected_queue);
-		    SET_NEXT(cmd, hostdata->disconnected_queue);
-		    hostdata->connected =3D NULL;
-		    hostdata->disconnected_queue =3D cmd;
-		    local_irq_restore(flags);
-		    dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %llu w=
as "
-			      "moved from connected to the "
-			      "disconnected_queue\n", HOSTNO,=20
-			      cmd->device->id, cmd->device->lun);
-		    /*=20
-		     * Restore phase bits to 0 so an interrupted selection,=20
-		     * arbitration can resume.
-		     */
-		    NCR5380_write(TARGET_COMMAND_REG, 0);
-
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    /* Wait for bus free to avoid nasty timeouts */
-		    while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connect=
ed)
-		    	barrier();
-#ifdef SUN3_SCSI_VME
-		    dregs->csr |=3D CSR_DMA_ENABLE;
-#endif
-		    return;
-		/*=20
-		 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
-		 * operation, in violation of the SCSI spec so we can safely=20
-		 * ignore SAVE/RESTORE pointers calls.
-		 *
-		 * Unfortunately, some disks violate the SCSI spec and=20
-		 * don't issue the required SAVE_POINTERS message before
-		 * disconnecting, and we have to break spec to remain=20
-		 * compatible.
-		 */
-		case SAVE_POINTERS:
-		case RESTORE_POINTERS:
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    break;
-		case EXTENDED_MESSAGE:
-/*=20
- * Extended messages are sent in the following format :
- * Byte =09
- * 0		EXTENDED_MESSAGE =3D=3D 1
- * 1		length (includes one byte for code, doesn't=20
- *		include first two bytes)
- * 2 		code
- * 3..length+1	arguments
- *
- * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since spi_print_msg() wants the whole thing. =20
- */
-		    extended_msg[0] =3D EXTENDED_MESSAGE;
-		    /* Accept first byte by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-		    dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n",=
 HOSTNO);
-
-		    len =3D 2;
-		    data =3D extended_msg + 1;
-		    phase =3D PHASE_MSGIN;
-		    NCR5380_transfer_pio(instance, &phase, &len, &data);
-		    dprintk(NDEBUG_EXTENDED, "scsi%d: length=3D%d, code=3D0x%02x\n",=
 HOSTNO,
-			       (int)extended_msg[1], (int)extended_msg[2]);
-
-		    if (!len && extended_msg[1] <=3D=20
-			(sizeof (extended_msg) - 1)) {
-			/* Accept third byte by clearing ACK */
-			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-			len =3D extended_msg[1] - 1;
-			data =3D extended_msg + 3;
-			phase =3D PHASE_MSGIN;
-
-			NCR5380_transfer_pio(instance, &phase, &len, &data);
-			dprintk(NDEBUG_EXTENDED, "scsi%d: message received, residual %d\n",
-				   HOSTNO, len);
-
-			switch (extended_msg[2]) {
-			case EXTENDED_SDTR:
-			case EXTENDED_WDTR:
-			case EXTENDED_MODIFY_DATA_POINTER:
-			case EXTENDED_EXTENDED_IDENTIFY:
-			    tmp =3D 0;
-			}
-		    } else if (len) {
-			printk(KERN_NOTICE "scsi%d: error receiving "
-			       "extended message\n", HOSTNO);
-			tmp =3D 0;
-		    } else {
-			printk(KERN_NOTICE "scsi%d: extended message "
-			       "code %02x length %d is too long\n",
-			       HOSTNO, extended_msg[2], extended_msg[1]);
-			tmp =3D 0;
-		    }
-		/* Fall through to reject message */
-
-		/*=20
-  		 * If we get something weird that we aren't expecting,=20
- 		 * reject it.
-		 */
-		default:
-		    if (!tmp) {
-			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			spi_print_msg(extended_msg);
-			printk("\n");
-		    } else if (tmp !=3D EXTENDED_MESSAGE)
-			printk(KERN_DEBUG "scsi%d: rejecting unknown "
-			       "message %02x from target %d, lun %llu\n",
-			       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
-		    else
-			printk(KERN_DEBUG "scsi%d: rejecting unknown "
-			       "extended message "
-			       "code %02x, length %d from target %d, lun %llu\n",
-			       HOSTNO, extended_msg[1], extended_msg[0],
-			       cmd->device->id, cmd->device->lun);
-  =20
-
-		    msgout =3D MESSAGE_REJECT;
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |=20
-			ICR_ASSERT_ATN);
-		    break;
-		} /* switch (tmp) */
-		break;
-	    case PHASE_MSGOUT:
-		len =3D 1;
-		data =3D &msgout;
-		hostdata->last_message =3D msgout;
-		NCR5380_transfer_pio(instance, &phase, &len, &data);
-		if (msgout =3D=3D ABORT) {
-#ifdef SUPPORT_TAGS
-		    cmd_free_tag( cmd );
-#else
-		    hostdata->busy[cmd->device->id] &=3D ~(1 << cmd->device->lun);
-#endif
-		    hostdata->connected =3D NULL;
-		    cmd->result =3D DID_ERROR << 16;
-		    cmd->scsi_done(cmd);
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    return;
-		}
-		msgout =3D NOP;
-		break;
-	    case PHASE_CMDOUT:
-		len =3D cmd->cmd_len;
-		data =3D cmd->cmnd;
-		/*=20
-		 * XXX for performance reasons, on machines with a=20
-		 * PSEUDO-DMA architecture we should probably=20
-		 * use the dma transfer function. =20
-		 */
-		NCR5380_transfer_pio(instance, &phase, &len,=20
-		    &data);
-		break;
-	    case PHASE_STATIN:
-		len =3D 1;
-		data =3D &tmp;
-		NCR5380_transfer_pio(instance, &phase, &len, &data);
-		cmd->SCp.Status =3D tmp;
-		break;
-	    default:
-		printk("scsi%d: unknown phase\n", HOSTNO);
-		NCR5380_dprint(NDEBUG_ANY, instance);
-	    } /* switch(phase) */
-	} /* if (tmp * SR_REQ) */=20
-    } /* while (1) */
-}
-
-/*
- * Function : void NCR5380_reselect (struct Scsi_Host *instance)
- *
- * Purpose : does reselection, initializing the instance->connected=20
- *	field to point to the struct scsi_cmnd for which the I_T_L or I_T_L=
_Q
- *	nexus has been reestablished,
- *=09
- * Inputs : instance - this instance of the NCR5380.
- *
- */
-
-/* it might eventually prove necessary to do a dma setup on
-   reselection, but it doesn't seem to be needed now -- sam */
-
-static void NCR5380_reselect (struct Scsi_Host *instance)
-{
-    SETUP_HOSTDATA(instance);
-    unsigned char target_mask;
-    unsigned char lun;
-#ifdef SUPPORT_TAGS
-    unsigned char tag;
-#endif
-    unsigned char msg[3];
-    struct scsi_cmnd *tmp =3D NULL, *prev;
-/*    unsigned long flags; */
-
-    /*
-     * Disable arbitration, etc. since the host adapter obviously
-     * lost, and tell an interrupted NCR5380_select() to restart.
-     */
-
-    NCR5380_write(MODE_REG, MR_BASE);
-    hostdata->restart_select =3D 1;
-
-    target_mask =3D NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->=
id_mask);
-
-    dprintk(NDEBUG_RESELECTION, "scsi%d: reselect\n", HOSTNO);
-
-    /*=20
-     * At this point, we have detected that our SCSI ID is on the bus,
-     * SEL is true and BSY was false for at least one bus settle delay
-     * (400 ns).
-     *
-     * We must assert BSY ourselves, until the target drops the SEL
-     * signal.
-     */
-
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
-   =20
-    while (NCR5380_read(STATUS_REG) & SR_SEL);
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-    /*
-     * Wait for target to go into MSGIN.
-     */
-
-    while (!(NCR5380_read(STATUS_REG) & SR_REQ));
-
-#if 1
-    // acknowledge toggle to MSGIN
-    NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(PHASE_MSGIN));
-
-    // peek at the byte without really hitting the bus
-    msg[0] =3D NCR5380_read(CURRENT_SCSI_DATA_REG);
-#endif
-
-    if (!(msg[0] & 0x80)) {
-	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO)=
;
-	spi_print_msg(msg);
-	do_abort(instance);
-	return;
-    }
-    lun =3D (msg[0] & 0x07);
-
-    /*=20
-     * Find the command corresponding to the I_T_L or I_T_L_Q  nexus w=
e=20
-     * just reestablished, and remove it from the disconnected queue.
-     */
-
-    for (tmp =3D (struct scsi_cmnd *) hostdata->disconnected_queue, pr=
ev =3D NULL;
-	 tmp; prev =3D tmp, tmp =3D NEXT(tmp) ) {
-	if ((target_mask =3D=3D (1 << tmp->device->id)) && (lun =3D=3D tmp->d=
evice->lun)
-#ifdef SUPPORT_TAGS
-	    && (tag =3D=3D tmp->tag)=20
-#endif
-	    ) {
-	    if (prev) {
-		REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
-		SET_NEXT(prev, NEXT(tmp));
-	    } else {
-		REMOVE(-1, hostdata->disconnected_queue, tmp, NEXT(tmp));
-		hostdata->disconnected_queue =3D NEXT(tmp);
-	    }
-	    SET_NEXT(tmp, NULL);
-	    break;
-	}
-    }
-   =20
-    if (!tmp) {
-	printk(KERN_WARNING "scsi%d: warning: target bitmask %02x lun %d "
-#ifdef SUPPORT_TAGS
-		"tag %d "
-#endif
-		"not in disconnected_queue.\n",
-		HOSTNO, target_mask, lun
-#ifdef SUPPORT_TAGS
-		, tag
-#endif
-		);
-	/*=20
-	 * Since we have an established nexus that we can't do anything
-	 * with, we must abort it. =20
-	 */
-	do_abort(instance);
-	return;
-    }
-#if 1
-    /* engage dma setup for the command we just saw */
-    {
-	    void *d;
-	    unsigned long count;
-
-	    if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
-		    count =3D tmp->SCp.buffer->length;
-		    d =3D SGADDR(tmp->SCp.buffer);
-	    } else {
-		    count =3D tmp->SCp.this_residual;
-		    d =3D tmp->SCp.ptr;
-	    }
-#ifdef REAL_DMA
-	    /* setup this command for dma if not already */
-	    if((count > SUN3_DMA_MINSIZE) && (sun3_dma_setup_done !=3D tmp))
-	    {
-		    sun3scsi_dma_setup(d, count, rq_data_dir(tmp->request));
-		    sun3_dma_setup_done =3D tmp;
-	    }
-#endif
-    }
-#endif
-
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
-    /* Accept message by clearing ACK */
-    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-#ifdef SUPPORT_TAGS
-    /* If the phase is still MSGIN, the target wants to send some more
-     * messages. In case it supports tagged queuing, this is probably =
a
-     * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
-     */
-    tag =3D TAG_NONE;
-    if (phase =3D=3D PHASE_MSGIN && setup_use_tagged_queuing) {
-	/* Accept previous IDENTIFY message by clearing ACK */
-	NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE );
-	len =3D 2;
-	data =3D msg+1;
-	if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
-	    msg[1] =3D=3D SIMPLE_QUEUE_TAG)
-	    tag =3D msg[2];
-	dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at=
 "
-		   "reselection\n", HOSTNO, target_mask, lun, tag);
-    }
-#endif
-   =20
-    hostdata->connected =3D tmp;
-    dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target =3D=
 %d, lun =3D %llu, tag =3D %d\n",
-	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
-}
-
-
-/*
- * Function : int NCR5380_abort(struct scsi_cmnd *cmd)
- *
- * Purpose : abort a command
- *
- * Inputs : cmd - the struct scsi_cmnd to abort, code - code to set th=
e
- * 	host byte of the result field to, if zero DID_ABORTED is=20
- *	used.
- *
- * Returns : 0 - success, -1 on failure.
- *
- * XXX - there is no way to abort the command that is currently=20
- * 	 connected, you have to wait for it to complete.  If this is=20
- *	 a problem, we could implement longjmp() / setjmp(), setjmp()
- * 	 called where the loop started in NCR5380_main().
- */
-
-static int NCR5380_abort(struct scsi_cmnd *cmd)
-{
-    struct Scsi_Host *instance =3D cmd->device->host;
-    SETUP_HOSTDATA(instance);
-    struct scsi_cmnd *tmp, **prev;
-    unsigned long flags;
-
-    printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
-    scsi_print_command(cmd);
-
-    NCR5380_print_status (instance);
-
-    local_irq_save(flags);
-   =20
-    dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x=
\n", HOSTNO,
-		NCR5380_read(BUS_AND_STATUS_REG),
-		NCR5380_read(STATUS_REG));
-
-#if 1
-/*=20
- * Case 1 : If the command is the currently executing command,=20
- * we'll set the aborted flag and return control so that=20
- * information transfer routine can exit cleanly.
- */
-
-    if (hostdata->connected =3D=3D cmd) {
-
-	dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO)=
;
-/*
- * We should perform BSY checking, and make sure we haven't slipped
- * into BUS FREE.
- */
-
-/*	NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_ATN); */
-/*=20
- * Since we can't change phases until we've completed the current=20
- * handshake, we have to source or sink a byte of data if the current
- * phase is not MSGOUT.
- */
-
-/*=20
- * Return control to the executing NCR drive so we can clear the
- * aborted flag and get back into our main loop.
- */=20
-
-	if (do_abort(instance) =3D=3D 0) {
-	  hostdata->aborted =3D 1;
-	  hostdata->connected =3D NULL;
-	  cmd->result =3D DID_ABORT << 16;
-#ifdef SUPPORT_TAGS
-	  cmd_free_tag( cmd );
-#else
-	  hostdata->busy[cmd->device->id] &=3D ~(1 << cmd->device->lun);
-#endif
-	  local_irq_restore(flags);
-	  cmd->scsi_done(cmd);
-	  return SUCCESS;
-	} else {
-/*	  local_irq_restore(flags); */
-	  printk("scsi%d: abort of connected command failed!\n", HOSTNO);
-	  return FAILED;
-	}=20
-   }
-#endif
-
-/*=20
- * Case 2 : If the command hasn't been issued yet, we simply remove it=
=20
- * 	    from the issue queue.
- */
-    for (prev =3D (struct scsi_cmnd **) &(hostdata->issue_queue),
-	tmp =3D (struct scsi_cmnd *) hostdata->issue_queue;
-	tmp; prev =3D NEXTADDR(tmp), tmp =3D NEXT(tmp))
-	if (cmd =3D=3D tmp) {
-	    REMOVE(5, *prev, tmp, NEXT(tmp));
-	    (*prev) =3D NEXT(tmp);
-	    SET_NEXT(tmp, NULL);
-	    tmp->result =3D DID_ABORT << 16;
-	    local_irq_restore(flags);
-	    dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue q=
ueue.\n",
-			HOSTNO);
-	    /* Tagged queuing note: no tag to free here, hasn't been assigned
-	     * yet... */
-	    tmp->scsi_done(tmp);
-	    return SUCCESS;
-	}
-
-/*=20
- * Case 3 : If any commands are connected, we're going to fail the abo=
rt
- *	    and let the high level SCSI driver retry at a later time or=20
- *	    issue a reset.
- *
- *	    Timeouts, and therefore aborted commands, will be highly unlike=
ly
- *          and handling them cleanly in this situation would make the=
 common
- *	    case of noresets less efficient, and would pollute our code.  S=
o,
- *	    we fail.
- */
-
-    if (hostdata->connected) {
-	local_irq_restore(flags);
-	dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", H=
OSTNO);
-        return FAILED;
-    }
-
-/*
- * Case 4: If the command is currently disconnected from the bus, and=20
- * 	there are no connected commands, we reconnect the I_T_L or=20
- *	I_T_L_Q nexus associated with it, go into message out, and send=20
- *      an abort message.
- *
- * This case is especially ugly. In order to reestablish the nexus, we
- * need to call NCR5380_select().  The easiest way to implement this=20
- * function was to abort if the bus was busy, and let the interrupt
- * handler triggered on the SEL for reselect take care of lost arbitra=
tions
- * where necessary, meaning interrupts need to be enabled.
- *
- * When interrupts are enabled, the queues may change - so we=20
- * can't remove it from the disconnected queue before selecting it
- * because that could cause a failure in hashing the nexus if that=20
- * device reselected.
- *=20
- * Since the queues may change, we can't use the pointers from when we
- * first locate it.
- *
- * So, we must first locate the command, and if NCR5380_select()
- * succeeds, then issue the abort, relocate the command and remove
- * it from the disconnected queue.
- */
-
-    for (tmp =3D (struct scsi_cmnd *) hostdata->disconnected_queue; tm=
p;
-	 tmp =3D NEXT(tmp))=20
-        if (cmd =3D=3D tmp) {
-            local_irq_restore(flags);
-	    dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n",=
 HOSTNO);
- =20
-	    if (NCR5380_select(instance, cmd))
-		return FAILED;
-
-	    dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
-
-	    do_abort (instance);
-
-	    local_irq_save(flags);
-	    for (prev =3D (struct scsi_cmnd **) &(hostdata->disconnected_queu=
e),
-		tmp =3D (struct scsi_cmnd *) hostdata->disconnected_queue;
-		tmp; prev =3D NEXTADDR(tmp), tmp =3D NEXT(tmp) )
-		    if (cmd =3D=3D tmp) {
-		    REMOVE(5, *prev, tmp, NEXT(tmp));
-		    *prev =3D NEXT(tmp);
-		    SET_NEXT(tmp, NULL);
-		    tmp->result =3D DID_ABORT << 16;
-		    /* We must unlock the tag/LUN immediately here, since the
-		     * target goes to BUS FREE and doesn't send us another
-		     * message (COMMAND_COMPLETE or the like)
-		     */
-#ifdef SUPPORT_TAGS
-		    cmd_free_tag( tmp );
-#else
-		    hostdata->busy[cmd->device->id] &=3D ~(1 << cmd->device->lun);
-#endif
-		    local_irq_restore(flags);
-		    tmp->scsi_done(tmp);
-		    return SUCCESS;
-		}
-	}
-
-/*
- * Case 5 : If we reached this point, the command was not found in any=
 of=20
- *	    the queues.
- *
- * We probably reached this point because of an unlikely race conditio=
n
- * between the command completing successfully and the abortion code,
- * so we won't panic, but we will notify the user in case something re=
ally
- * broke.
- */
-
-    local_irq_restore(flags);
-    printk(KERN_INFO "scsi%d: warning : SCSI command probably complete=
d successfully before abortion\n", HOSTNO);=20
-
-    return FAILED;
-}
-
-
-/*=20
- * Function : int NCR5380_bus_reset(struct scsi_cmnd *cmd)
- *=20
- * Purpose : reset the SCSI bus.
- *
- * Returns : SUCCESS or FAILURE
- *
- */=20
-
-static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
-{
-    SETUP_HOSTDATA(cmd->device->host);
-    int           i;
-    unsigned long flags;
-#if defined(RESET_RUN_DONE)
-    struct scsi_cmnd *connected, *disconnected_queue;
-#endif
-
-
-    NCR5380_print_status (cmd->device->host);
-
-    /* get in phase */
-    NCR5380_write( TARGET_COMMAND_REG,
-		   PHASE_SR_TO_TCR( NCR5380_read(STATUS_REG) ));
-    /* assert RST */
-    NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST );
-    udelay (40);
-    /* reset NCR registers */
-    NCR5380_write( INITIATOR_COMMAND_REG, ICR_BASE );
-    NCR5380_write( MODE_REG, MR_BASE );
-    NCR5380_write( TARGET_COMMAND_REG, 0 );
-    NCR5380_write( SELECT_ENABLE_REG, 0 );
-    /* ++roman: reset interrupt condition! otherwise no interrupts don=
't get
-     * through anymore ... */
-    (void)NCR5380_read( RESET_PARITY_INTERRUPT_REG );
-
-	/* MSch 20140115 - looking at the generic NCR5380 driver, all of this
-	 * should go.
-	 * Catch-22: if we don't clear all queues, the SCSI driver lock will
-	 * not be released by atari_scsi_reset()!
-	 */
-
-#if defined(RESET_RUN_DONE)
-	/* XXX Should now be done by midlevel code, but it's broken XXX */
-	/* XXX see below                                            XXX */
-
-    /* MSch: old-style reset: actually abort all command processing he=
re */
-
-    /* After the reset, there are no more connected or disconnected co=
mmands
-     * and no busy units; to avoid problems with re-inserting the comm=
ands
-     * into the issue_queue (via scsi_done()), the aborted commands ar=
e
-     * remembered in local variables first.
-     */
-    local_irq_save(flags);
-    connected =3D (struct scsi_cmnd *)hostdata->connected;
-    hostdata->connected =3D NULL;
-    disconnected_queue =3D (struct scsi_cmnd *)hostdata->disconnected_=
queue;
-    hostdata->disconnected_queue =3D NULL;
-#ifdef SUPPORT_TAGS
-    free_all_tags();
-#endif
-    for( i =3D 0; i < 8; ++i )
-	hostdata->busy[i] =3D 0;
-#ifdef REAL_DMA
-    hostdata->dma_len =3D 0;
-#endif
-    local_irq_restore(flags);
-
-    /* In order to tell the mid-level code which commands were aborted=
,=20
-     * set the command status to DID_RESET and call scsi_done() !!!
-     * This ultimately aborts processing of these commands in the mid-=
level.
-     */
-
-    if ((cmd =3D connected)) {
-	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", =
H_NO(cmd));
-	cmd->result =3D (cmd->result & 0xffff) | (DID_RESET << 16);
-	cmd->scsi_done( cmd );
-    }
-
-    for (i =3D 0; (cmd =3D disconnected_queue); ++i) {
-	disconnected_queue =3D NEXT(cmd);
-	SET_NEXT(cmd, NULL);
-	cmd->result =3D (cmd->result & 0xffff) | (DID_RESET << 16);
-	cmd->scsi_done( cmd );
-    }
-    if (i > 0)
-	dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)=
\n", i);
-
-
-    /* since all commands have been explicitly terminated, we need to =
tell
-     * the midlevel code that the reset was SUCCESSFUL, and there is n=
o=20
-     * need to 'wake up' the commands by a request_sense
-     */
-    return SUCCESS;
-#else /* 1 */
-
-    /* MSch: new-style reset handling: let the mid-level do what it ca=
n */
-
-    /* ++guenther: MID-LEVEL IS STILL BROKEN.
-     * Mid-level is supposed to requeue all commands that were active =
on the
-     * various low-level queues. In fact it does this, but that's not =
enough
-     * because all these commands are subject to timeout. And if a tim=
eout
-     * happens for any removed command, *_abort() is called but all qu=
eues
-     * are now empty. Abort then gives up the falcon lock, which is fa=
tal,
-     * since the mid-level will queue more commands and must have the =
lock
-     * (it's all happening inside timer interrupt handler!!).
-     * Even worse, abort will return NOT_RUNNING for all those command=
s not
-     * on any queue, so they won't be retried ...
-     *
-     * Conclusion: either scsi.c disables timeout for all resetted com=
mands
-     * immediately, or we lose!  As of linux-2.0.20 it doesn't.
-     */
-
-    /* After the reset, there are no more connected or disconnected co=
mmands
-     * and no busy units; so clear the low-level status here to avoid=20
-     * conflicts when the mid-level code tries to wake up the affected=
=20
-     * commands!
-     */
-
-    if (hostdata->issue_queue)
-	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_=
NO(cmd));
-    if (hostdata->connected)=20
-	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", =
H_NO(cmd));
-    if (hostdata->disconnected_queue)
-	dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\=
n", H_NO(cmd));
-
-    local_irq_save(flags);
-    hostdata->issue_queue =3D NULL;
-    hostdata->connected =3D NULL;
-    hostdata->disconnected_queue =3D NULL;
-#ifdef SUPPORT_TAGS
-    free_all_tags();
-#endif
-    for( i =3D 0; i < 8; ++i )
-	hostdata->busy[i] =3D 0;
-#ifdef REAL_DMA
-    hostdata->dma_len =3D 0;
-#endif
-    local_irq_restore(flags);
-
-    /* we did no complete reset of all commands, so a wakeup is requir=
ed */
-    return SUCCESS;
-#endif /* 1 */
-}
-
-/* Local Variables: */
-/* tab-width: 8     */
-/* End:             */
