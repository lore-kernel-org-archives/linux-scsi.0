From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] start moving and splitting the scsi headers
Date: Mon, 9 Jun 2003 17:17:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609151711.GB1325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:14734 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263823AbTFIPDk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 11:03:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This patch adds the following new files:

  include/scsi/scsi_cmnd.h
  include/scsi/scsi_device.h
  include/scsi/scsi_host.h

for each of the major scsi core data structures and makes the
old scsi.h and hosts.h include them for compatibality.  In the
next round of patches all reamining contents of those will
move to proper locations.


diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Sun Jun  8 19:19:25 2003
+++ b/drivers/scsi/hosts.h	Sun Jun  8 19:19:25 2003
@@ -28,519 +28,11 @@
 #include <linux/proc_fs.h>
 #include <linux/types.h>
 
-struct scsi_host_cmd_pool;
+#include <scsi/scsi_host.h>
 
-
-/* It is senseless to set SG_ALL any higher than this - the performance
- *  does not get any better, and it wastes memory
- */
-#define SG_NONE 0
-#define SG_ALL 0xff
-
-#define DISABLE_CLUSTERING 0
-#define ENABLE_CLUSTERING 1
-
-/* The various choices mean:
- * NONE: Self evident.	Host adapter is not capable of scatter-gather.
- * ALL:	 Means that the host adapter module can do scatter-gather,
- *	 and that there is no limit to the size of the table to which
- *	 we scatter/gather data.
- * Anything else:  Indicates the maximum number of chains that can be
- *	 used in one scatter-gather request.
- */
-
-struct scsi_host_template {
-    /* Used with loadable modules so that we know when it is safe to unload */
-    struct module * module;
-
-    /* The pointer to the /proc/scsi directory entry */
-    struct proc_dir_entry *proc_dir;
-
-    /* proc-fs info function.
-     * Can be used to export driver statistics and other infos to the world
-     * outside the kernel ie. userspace and it also provides an interface
-     * to feed the driver with information. Check eata_dma_proc.c for reference
-     */
-    int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
-
-    /*
-     * The name pointer is a pointer to the name of the SCSI
-     * device detected.
-     */
-    const char *name;
-
-    /*
-     * The detect function shall return non zero on detection,
-     * indicating the number of host adapters of this particular
-     * type were found.	 It should also
-     * initialize all data necessary for this particular
-     * SCSI driver.  It is passed the host number, so this host
-     * knows where the first entry is in the scsi_hosts[] array.
-     *
-     * Note that the detect routine MUST not call any of the mid level
-     * functions to queue commands because things are not guaranteed
-     * to be set up yet.  The detect routine can send commands to
-     * the host adapter as long as the program control will not be
-     * passed to scsi.c in the processing of the command.  Note
-     * especially that scsi_malloc/scsi_free must not be called.
-     */
-    int (* detect)(struct scsi_host_template *);
-
-    /* Used with loadable modules to unload the host structures.  Note:
-     * there is a default action built into the modules code which may
-     * be sufficient for most host adapters.  Thus you may not have to supply
-     * this at all.
-     */
-    int (*release)(struct Scsi_Host *);
-
-    /*
-     * The info function will return whatever useful
-     * information the developer sees fit.  If not provided, then
-     * the name field will be used instead.
-     */
-    const char *(* info)(struct Scsi_Host *);
-
-    /*
-     * ioctl interface
-     */
-    int (*ioctl)(struct scsi_device *dev, int cmd, void *arg);
-
-    /*
-     * The command function takes a target, a command (this is a SCSI
-     * command formatted as per the SCSI spec, nothing strange), a
-     * data buffer pointer, and data buffer length pointer.  The return
-     * is a status int, bit fielded as follows :
-     * Byte What
-     * 0    SCSI status code
-     * 1    SCSI 1 byte message
-     * 2    host error return.
-     * 3    mid level error return
-     */
-    int (* command)(struct scsi_cmnd *);
-
-    /*
-     * The QueueCommand function works in a similar manner
-     * to the command function.	 It takes an additional parameter,
-     * void (* done)(int host, int code) which is passed the host
-     * # and exit result when the command is complete.
-     * Host number is the POSITION IN THE hosts array of THIS
-     * host adapter.
-     *
-     * if queuecommand returns 0, then the HBA has accepted the
-     * command.  The done() function must be called on the command
-     * when the driver has finished with it. (you may call done on the
-     * command before queuecommand returns, but in this case you
-     * *must* return 0 from queuecommand).
-     *
-     * queuecommand may also reject the command, in which case it may
-     * not touch the command and must not call done() for it.
-     *
-     * There are two possible rejection returns:
-     *
-     *   SCSI_MLQUEUE_DEVICE_BUSY: Block this device temporarily, but
-     *   allow commands to other devices serviced by this host.
-     *
-     *   SCSI_MLQUEUE_HOST_BUSY: Block all devices served by this
-     *   host temporarily.
-     *
-     *   for compatibility, any other non-zero return is treated the
-     *   same as SCSI_MLQUEUE_HOST_BUSY.
-     *
-     *   NOTE: "temporarily" means either until the next command for
-     *   this device/host completes, or a period of time determined by
-     *   I/O pressure in the system if there are no other outstanding
-     *   commands.
-     * */
-    int (* queuecommand)(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
-
-    /*
-     * This is an error handling strategy routine.  You don't need to
-     * define one of these if you don't want to - there is a default
-     * routine that is present that should work in most cases.  For those
-     * driver authors that have the inclination and ability to write their
-     * own strategy routine, this is where it is specified.  Note - the
-     * strategy routine is *ALWAYS* run in the context of the kernel eh
-     * thread.  Thus you are guaranteed to *NOT* be in an interrupt handler
-     * when you execute this, and you are also guaranteed to *NOT* have any
-     * other commands being queued while you are in the strategy routine.
-     * When you return from this function, operations return to normal.
-     *
-     * See scsi_error.c scsi_unjam_host for additional comments about what
-     * this function should and should not be attempting to do.
-     */
-     int (*eh_strategy_handler)(struct Scsi_Host *);
-     int (*eh_abort_handler)(struct scsi_cmnd *);
-     int (*eh_device_reset_handler)(struct scsi_cmnd *);
-     int (*eh_bus_reset_handler)(struct scsi_cmnd *);
-     int (*eh_host_reset_handler)(struct scsi_cmnd *);
-
-    /*
-     * Old EH handlers, no longer used. Make them warn the user of old
-     * drivers by using a wrong type
-     */
-    int (*abort)(int);
-    int (*reset)(int,int);
-
-    /*
-     * slave_alloc()  -  Optional
-     * 
-     * Before the mid layer attempts to scan for a new device where none
-     * currently exists, it will call this entry in your driver.  Should
-     * your driver need to allocate any structs or perform any other init
-     * items in order to send commands to a currently unused target/lun
-     * combo, then this is where you can perform those allocations.  This
-     * is specifically so that drivers won't have to perform any kind of
-     * "is this a new device" checks in their queuecommand routine,
-     * thereby making the hot path a bit quicker.
-     *
-     * Return values: 0 on success, non-0 on failure
-     *
-     * Deallocation:  If we didn't find any devices at this ID, you will
-     * get an immediate call to slave_destroy().  If we find something here
-     * then you will get a call to slave_configure(), then the device will be
-     * used for however long it is kept around, then when the device is
-     * removed from the system (or * possibly at reboot time), you will
-     * then get a call to slave_detach().  This is assuming you implement
-     * slave_configure and slave_destroy.  However, if you allocate memory
-     * and hang it off the device struct, then you must implement the
-     * slave_destroy() routine at a minimum in order to avoid leaking memory
-     * each time a device is tore down.
-     */
-    int (* slave_alloc)(struct scsi_device *);
-
-    /*
-     * slave_configure()  -  Optional
-     * 
-     * Once the device has responded to an INQUIRY and we know the device
-     * is online, we call into the low level driver with the struct scsi_device *
-     * If the low level device driver implements this function, it *must*
-     * perform the task of setting the queue depth on the device.  All other
-     * tasks are optional and depend on what the driver supports and various
-     * implementation details.
-     * 
-     * Things currently recommended to be handled at this time include:
-     *
-     * 1.  Setting the device queue depth.  Proper setting of this is
-     *     described in the comments for scsi_adjust_queue_depth.
-     * 2.  Determining if the device supports the various synchronous
-     *     negotiation protocols.  The device struct will already have
-     *     responded to INQUIRY and the results of the standard items
-     *     will have been shoved into the various device flag bits, eg.
-     *     device->sdtr will be true if the device supports SDTR messages.
-     * 3.  Allocating command structs that the device will need.
-     * 4.  Setting the default timeout on this device (if needed).
-     * 5.  Anything else the low level driver might want to do on a device
-     *     specific setup basis...
-     * 6.  Return 0 on success, non-0 on error.  The device will be marked
-     *     as offline on error so that no access will occur.  If you return
-     *     non-0, your slave_detach routine will never get called for this
-     *     device, so don't leave any loose memory hanging around, clean
-     *     up after yourself before returning non-0
-     */
-    int (* slave_configure)(struct scsi_device *);
-
-    /*
-     * slave_destroy()  -  Optional
-     *
-     * Immediately prior to deallocating the device and after all activity
-     * has ceased the mid layer calls this point so that the low level driver
-     * may completely detach itself from the scsi device and vice versa.
-     * The low level driver is responsible for freeing any memory it allocated
-     * in the slave_alloc or slave_configure calls. 
-     */
-    void (* slave_destroy)(struct scsi_device *);
-
-    /*
-     * This function determines the bios parameters for a given
-     * harddisk.  These tend to be numbers that are made up by
-     * the host adapter.  Parameters:
-     * size, device, list (heads, sectors, cylinders)
-     */
-    int (* bios_param)(struct scsi_device *, struct block_device *,
-		    sector_t, int []);
-
-    /*
-     * This determines if we will use a non-interrupt driven
-     * or an interrupt driven scheme,  It is set to the maximum number
-     * of simultaneous commands a given host adapter will accept.
-     */
-    int can_queue;
-
-    /*
-     * In many instances, especially where disconnect / reconnect are
-     * supported, our host also has an ID on the SCSI bus.  If this is
-     * the case, then it must be reserved.  Please set this_id to -1 if
-     * your setup is in single initiator mode, and the host lacks an
-     * ID.
-     */
-    int this_id;
-
-    /*
-     * This determines the degree to which the host adapter is capable
-     * of scatter-gather.
-     */
-    short unsigned int sg_tablesize;
-
-    /*
-     * if the host adapter has limitations beside segment count
-     */
-    short unsigned int max_sectors;
-
-    /*
-     * True if this host adapter can make good use of linked commands.
-     * This will allow more than one command to be queued to a given
-     * unit on a given host.  Set this to the maximum number of command
-     * blocks to be provided for each device.  Set this to 1 for one
-     * command block per lun, 2 for two, etc.  Do not set this to 0.
-     * You should make sure that the host adapter will do the right thing
-     * before you try setting this above 1.
-     */
-    short cmd_per_lun;
-
-    /*
-     * present contains counter indicating how many boards of this
-     * type were found when we did the scan.
-     */
-    unsigned char present;
-
-    /*
-     * true if this host adapter uses unchecked DMA onto an ISA bus.
-     */
-    unsigned unchecked_isa_dma:1;
-
-    /*
-     * true if this host adapter can make good use of clustering.
-     * I originally thought that if the tablesize was large that it
-     * was a waste of CPU cycles to prepare a cluster list, but
-     * it works out that the Buslogic is faster if you use a smaller
-     * number of segments (i.e. use clustering).  I guess it is
-     * inefficient.
-     */
-    unsigned use_clustering:1;
-
-    /*
-     * True for emulated SCSI host adapters (e.g. ATAPI)
-     */
-    unsigned emulated:1;
-
-    unsigned highmem_io:1;
-
-    /* 
-     * True if the driver wishes to use the generic block layer
-     * tag queueing functions
-     */
-    unsigned use_blk_tcq:1;
-
-    /*
-     * Name of proc directory
-     */
-    char *proc_name;
-
-    /*
-     * countdown for host blocking with no commands outstanding
-     */
-    unsigned int max_host_blocked;
-
-    /*
-     * Default value for the blocking.  If the queue is empty, host_blocked
-     * counts down in the request_fn until it restarts host operations as
-     * zero is reached.  
-     *
-     * FIXME: This should probably be a value in the template */
-    #define SCSI_DEFAULT_HOST_BLOCKED	7
-
-    /*
-     * pointer to the sysfs class properties for this host
-     */
-    struct class_device_attribute **shost_attrs;
-
-    /*
-     * Pointer to the SCSI device properties for this host
-     */
-    struct device_attribute **sdev_attrs;
-
-    /*
-     * List of hosts per template.
-     *
-     * This is only for use by scsi_module.c for legacy templates.
-     * For these access to it is synchronized implicitly by
-     * module_init/module_exit.
-     */
-    struct list_head legacy_hosts;
-};
-
-struct Scsi_Host {
-/* private: */
-    /*
-     * This information is private to the scsi mid-layer.  Wrapping it in a
-     * struct private is a way of marking it in a sort of C++ type of way.
-     */
-    struct list_head	  my_devices;
-
-    struct scsi_host_cmd_pool *cmd_pool;
-    spinlock_t            free_list_lock;
-    struct list_head      free_list;   /* backup store of cmd structs */
-    struct list_head      starved_list;
-
-    spinlock_t		  default_lock;
-    spinlock_t		  *host_lock;
-
-    struct list_head	eh_cmd_q;
-    struct task_struct    * ehandler;  /* Error recovery thread. */
-    struct semaphore      * eh_wait;   /* The error recovery thread waits on
-                                          this. */
-    struct completion     * eh_notify; /* wait for eh to begin or end */
-    struct semaphore      * eh_action; /* Wait for specific actions on the
-                                          host. */
-    unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
-                                          this is true. */
-    unsigned int            eh_kill:1; /* set when killing the eh thread */
-    wait_queue_head_t       host_wait;
-    struct scsi_host_template *hostt;
-    volatile unsigned short host_busy;   /* commands actually active on low-level */
-    volatile unsigned short host_failed; /* commands that failed. */
-    
-/* public: */
-    unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
-    int resetting; /* if set, it means that last_reset is a valid value */
-    unsigned long last_reset;
-
-    /*
-     *	These three parameters can be used to allow for wide scsi,
-     *	and for host adapters that support multiple busses
-     *	The first two should be set to 1 more than the actual max id
-     *	or lun (i.e. 8 for normal systems).
-     */
-    unsigned int max_id;
-    unsigned int max_lun;
-    unsigned int max_channel;
-
-    /* These parameters should be set by the detect routine */
-    unsigned long base;
-    unsigned long io_port;
-    unsigned char n_io_port;
-    unsigned char dma_channel;
-    unsigned int  irq;
-
-    /*
-     * This is a unique identifier that must be assigned so that we
-     * have some way of identifying each detected host adapter properly
-     * and uniquely.  For hosts that do not support more than one card
-     * in the system at one time, this does not need to be set.  It is
-     * initialized to 0 in scsi_register.
-     */
-    unsigned int unique_id;
-
-    /*
-     * The rest can be copied from the template, or specifically
-     * initialized, as required.
-     */
-
-    /*
-     * The maximum length of SCSI commands that this host can accept.
-     * Probably 12 for most host adapters, but could be 16 for others.
-     * For drivers that don't set this field, a value of 12 is
-     * assumed.  I am leaving this as a number rather than a bit
-     * because you never know what subsequent SCSI standards might do
-     * (i.e. could there be a 20 byte or a 24-byte command a few years
-     * down the road?).  
-     */
-    unsigned char max_cmd_len;
-
-    int this_id;
-    int can_queue;
-    short cmd_per_lun;
-    short unsigned int sg_tablesize;
-    short unsigned int max_sectors;
-
-    unsigned in_recovery:1;
-    unsigned unchecked_isa_dma:1;
-    unsigned use_clustering:1;
-    unsigned highmem_io:1;
-    unsigned use_blk_tcq:1;
-
-    /*
-     * Host has requested that no further requests come through for the
-     * time being.
-     */
-    unsigned host_self_blocked:1;
-    
-    /*
-     * Host uses correct SCSI ordering not PC ordering. The bit is
-     * set for the minority of drivers whose authors actually read the spec ;)
-     */
-    unsigned reverse_ordering:1;
-
-    /*
-     * Host has rejected a command because it was busy.
-     */
-    unsigned int host_blocked;
-
-    /*
-     * Value host_blocked counts down from
-     */
-    unsigned int max_host_blocked;
-
-    /* 
-     * Support for sysfs
-     */
-    struct device host_gendev;
-    struct class_device class_dev;
-
-    /*
-     * List of hosts per template.
-     *
-     * This is only for use by scsi_module.c for legacy templates.
-     * For these access to it is synchronized implicitly by
-     * module_init/module_exit.
-     */
-    struct list_head sht_legacy_list;
-
-    /*
-     * We should ensure that this is aligned, both for better performance
-     * and also because some compilers (m68k) don't automatically force
-     * alignment to a long boundary.
-     */
-    unsigned long hostdata[0]  /* Used for storage of host specific stuff */
-        __attribute__ ((aligned (sizeof(unsigned long))));
-};
-
-#define		dev_to_shost(d)		\
-	container_of(d, struct Scsi_Host, host_gendev)
-#define		class_to_shost(d)	\
-	container_of(d, struct Scsi_Host, class_dev)
-
-/*
- * These two functions are used to allocate and free a pseudo device
- * which will connect to the host adapter itself rather than any
- * physical device.  You must deallocate when you are done with the
- * thing.  This physical pseudo-device isn't real and won't be available
- * from any high-level drivers.
- */
-extern void scsi_free_host_dev(struct scsi_device *);
-extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
-
-extern void scsi_unblock_requests(struct Scsi_Host *);
-extern void scsi_block_requests(struct Scsi_Host *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 
-static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
-{
-	shost->host_lock = lock;
-}
-
-static inline void scsi_set_device(struct Scsi_Host *shost,
-                                   struct device *dev)
-{
-        shost->host_gendev.parent = dev;
-}
-
-static inline struct device *scsi_get_device(struct Scsi_Host *shost)
-{
-        return shost->host_gendev.parent;
-}
-
 struct scsi_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
@@ -560,17 +52,6 @@
 	class_interface_unregister(intf)
 
 
-extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
-extern int scsi_add_host(struct Scsi_Host *, struct device *);
-extern int scsi_remove_host(struct Scsi_Host *);
-extern void scsi_host_get(struct Scsi_Host *);
-extern void scsi_host_put(struct Scsi_Host *t);
-extern struct Scsi_Host *scsi_host_lookup(unsigned short);
-
-/* legacy interfaces */
-extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
-extern void scsi_unregister(struct Scsi_Host *);
-
 /**
  * scsi_find_device - find a device given the host
  * @shost:	SCSI host pointer
@@ -588,7 +69,5 @@
                         return sdev;
         return NULL;
 }
-
-extern void scsi_sysfs_release_attributes(struct scsi_host_template *hostt);
 
 #endif
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sun Jun  8 19:19:25 2003
+++ b/drivers/scsi/scsi.h	Sun Jun  8 19:19:25 2003
@@ -16,6 +16,9 @@
 #define _SCSI_H
 
 #include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi.h>
 
 /*
@@ -112,19 +115,6 @@
 #define SOFT_ERROR      0x2005
 #define ADD_TO_MLQUEUE  0x2006
 
-/*
- * These are the values that scsi_cmd->state can take.
- */
-#define SCSI_STATE_TIMEOUT         0x1000
-#define SCSI_STATE_FINISHED        0x1001
-#define SCSI_STATE_FAILED          0x1002
-#define SCSI_STATE_QUEUED          0x1003
-#define SCSI_STATE_UNUSED          0x1006
-#define SCSI_STATE_DISCONNECTING   0x1008
-#define SCSI_STATE_INITIALIZING    0x1009
-#define SCSI_STATE_BHQUEUE         0x100a
-#define SCSI_STATE_MLQUEUE         0x100b
-
 #define IDENTIFY_BASE       0x80
 #define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
 		     ((can_disconnect) ?  0x40 : 0) |\
@@ -169,9 +159,6 @@
 #define DRIVER_MASK         0x0f
 #define SUGGEST_MASK        0xf0
 
-#define MAX_COMMAND_SIZE    16
-#define SCSI_SENSE_BUFFERSIZE   64
-
 /*
  *  SCSI command sets
  */
@@ -204,15 +191,6 @@
 #define ASKED_FOR_SENSE 0x20
 #define SYNC_RESET      0x40
 
-/*
- * This specifies "machine infinity" for host templates which don't
- * limit the transfer size.  Note this limit represents an absolute
- * maximum, and may be over the transfer limits allowed for individual
- * devices (e.g. 256 for SCSI-1)
- */
-#define SCSI_DEFAULT_MAX_SECTORS	1024
-
-
 struct Scsi_Host;
 struct scsi_cmnd;
 struct scsi_device;
@@ -236,22 +214,6 @@
                     unsigned int *secs);
 
 /*
- * Prototypes for functions in scsi_lib.c
- */
-extern void scsi_io_completion(struct scsi_cmnd *, int, int);
-
-/*
- * Prototypes for functions in scsi.c
- */
-extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
-extern void scsi_put_command(struct scsi_cmnd *cmd);
-extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
-extern int scsi_track_queue_full(struct scsi_device *, int);
-extern int scsi_device_get(struct scsi_device *);
-extern void scsi_device_put(struct scsi_device *);
-extern void scsi_set_device_offline(struct scsi_device *);
-
-/*
  * Newer request-based interfaces.
  */
 extern struct scsi_request *scsi_allocate_request(struct scsi_device *);
@@ -264,13 +226,6 @@
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
 
-/*
- * Prototypes for functions in scsi_scan.c
- */
-extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
-		uint, uint, uint);
-extern int scsi_remove_device(struct scsi_device *);
-extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
 /*
  * Prototypes for functions in constants.c
@@ -287,120 +242,6 @@
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
-
-/*
- *  The scsi_device struct contains what we know about each given scsi
- *  device.
- *
- * FIXME(eric) - One of the great regrets that I have is that I failed to
- * define these structure elements as something like sdev_foo instead of foo.
- * This would make it so much easier to grep through sources and so forth.
- * I propose that all new elements that get added to these structures follow
- * this convention.  As time goes on and as people have the stomach for it,
- * it should be possible to go back and retrofit at least some of the elements
- * here with with the prefix.
- */
-
-struct scsi_device {
-	struct class_device	sdev_classdev;
-	/*
-	 * This information is private to the scsi mid-layer.
-	 */
-	struct list_head    siblings;   /* list of all devices on this host */
-	struct list_head    same_target_siblings; /* just the devices sharing same target id */
-	struct Scsi_Host *host;
-	struct request_queue *request_queue;
-	volatile unsigned short device_busy;	/* commands actually active on low-level */
-	spinlock_t sdev_lock;           /* also the request queue_lock */
-	spinlock_t list_lock;
-	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
-	struct list_head starved_entry;
-	struct scsi_cmnd *current_cmnd;	/* currently active command */
-	unsigned short queue_depth;	/* How deep of a queue we want */
-	unsigned short last_queue_full_depth; /* These two are used by */
-	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
-	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same
-					   jiffie count on our counter, they
-					   could all be from the same event. */
-
-	unsigned int id, lun, channel;
-
-	unsigned int manufacturer;	/* Manufacturer of device, for using 
-					 * vendor-specific cmd's */
-	unsigned sector_size;	/* size in bytes */
-
-	int access_count;	/* Count of open channels/mounts */
-
-	void *hostdata;		/* available to low-level driver */
-	char devfs_name[256];	/* devfs junk */
-	char type;
-	char scsi_level;
-	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
-	unsigned char * inquiry;	/* INQUIRY response data */
-	char * vendor;		/* [back_compat] point into 'inquiry' ... */
-	char * model;		/* ... after scan; point to static string */
-	char * rev;		/* ... "nullnullnullnull" before scan */
-	unsigned char current_tag;	/* current tag */
-	struct scsi_target      *sdev_target;   /* used only for single_lun */
-
-	unsigned online:1;
-
-	unsigned writeable:1;
-	unsigned removable:1;
-	unsigned changed:1;	/* Data invalid due to media change */
-	unsigned busy:1;	/* Used to prevent races */
-	unsigned lockable:1;	/* Able to prevent media removal */
-	unsigned locked:1;      /* Media removal disabled */
-	unsigned borken:1;	/* Tell the Seagate driver to be 
-				 * painfully slow on this device */
-	unsigned disconnect:1;	/* can disconnect */
-	unsigned soft_reset:1;	/* Uses soft reset option */
-	unsigned sdtr:1;	/* Device supports SDTR messages */
-	unsigned wdtr:1;	/* Device supports WDTR messages */
-	unsigned ppr:1;		/* Device supports PPR messages */
-	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
-	unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
-				   instead!!!  Please fix your driver now!! */
-	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
-	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */
-	unsigned single_lun:1;	/* Indicates we should only allow I/O to
-				 * one of the luns for the device at a 
-				 * time. */
-	unsigned was_reset:1;	/* There was a bus reset on the bus for 
-				 * this device */
-	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
-				     * because we did a bus reset. */
-	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
-	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
-	unsigned no_start_on_add:1;	/* do not issue start on add */
-
-	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
-
-	unsigned int max_device_blocked; /* what device_blocked counts down from  */
-  	/* default value if the device doesn't override */
-	#define SCSI_DEFAULT_DEVICE_BLOCKED	3
-
-	struct device sdev_driverfs_dev;
-};
-#define	to_scsi_device(d)	\
-	container_of(d, struct scsi_device, sdev_driverfs_dev)
-
-
-struct scsi_pointer {
-	char *ptr;		/* data pointer */
-	int this_residual;	/* left in this buffer */
-	struct scatterlist *buffer;	/* which buffer */
-	int buffers_residual;	/* how many buffers left */
-
-        dma_addr_t dma_handle;
-
-	volatile int Status;
-	volatile int Message;
-	volatile int have_data_in;
-	volatile int sent_command;
-	volatile int phase;
-};
-
 /*
  * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
  * having this is that requests that are injected into the queue as result
@@ -438,131 +279,6 @@
 };
 
 /*
- * FIXME(eric) - one of the great regrets that I have is that I failed to
- * define these structure elements as something like sc_foo instead of foo.
- * This would make it so much easier to grep through sources and so forth.
- * I propose that all new elements that get added to these structures follow
- * this convention.  As time goes on and as people have the stomach for it,
- * it should be possible to go back and retrofit at least some of the elements
- * here with with the prefix.
- */
-struct scsi_cmnd {
-	int     sc_magic;
-
-	struct scsi_device *device;
-	unsigned short state;
-	unsigned short owner;
-	struct scsi_request *sc_request;
-
-	struct list_head list;  /* scsi_cmnd participates in queue lists */
-
-	struct list_head eh_entry; /* entry for the host eh_cmd_q */
-	int eh_state;		/* Used for state tracking in error handlr */
-	int eh_eflags;		/* Used by error handlr */
-	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
-	/*
-	   A SCSI Command is assigned a nonzero serial_number when internal_cmnd
-	   passes it to the driver's queue command function.  The serial_number
-	   is cleared when scsi_done is entered indicating that the command has
-	   been completed.  If a timeout occurs, the serial number at the moment
-	   of timeout is copied into serial_number_at_timeout.  By subsequently
-	   comparing the serial_number and serial_number_at_timeout fields
-	   during abort or reset processing, we can detect whether the command
-	   has already completed.  This also detects cases where the command has
-	   completed and the SCSI Command structure has already being reused
-	   for another command, so that we can avoid incorrectly aborting or
-	   resetting the new command.
-	 */
-
-	unsigned long serial_number;
-	unsigned long serial_number_at_timeout;
-
-	int retries;
-	int allowed;
-	int timeout_per_command;
-	int timeout_total;
-	int timeout;
-
-	/*
-	 * We handle the timeout differently if it happens when a reset, 
-	 * abort, etc are in process. 
-	 */
-	unsigned volatile char internal_timeout;
-
-	unsigned char cmd_len;
-	unsigned char old_cmd_len;
-	unsigned char sc_data_direction;
-	unsigned char sc_old_data_direction;
-
-	/* These elements define the operation we are about to perform */
-	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned request_bufflen;	/* Actual request size */
-
-	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
-
-	/* These elements define the operation we ultimately want to perform */
-	unsigned char data_cmnd[MAX_COMMAND_SIZE];
-	unsigned short old_use_sg;	/* We save  use_sg here when requesting
-					 * sense info */
-	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
-	unsigned short abort_reason;	/* If the mid-level code requests an
-					 * abort, this is the reason. */
-	unsigned bufflen;	/* Size of data buffer */
-	void *buffer;		/* Data buffer */
-
-	unsigned underflow;	/* Return error if less than
-				   this amount is transferred */
-	unsigned old_underflow;	/* save underflow here when reusing the
-				 * command for error handling */
-
-	unsigned transfersize;	/* How much we are guaranteed to
-				   transfer with each SCSI transfer
-				   (ie, between disconnect / 
-				   reconnects.   Probably == sector
-				   size */
-
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
-	struct request *request;	/* The command we are
-				   	   working on */
-
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
-						 * when CHECK CONDITION is
-						 * received on original command 
-						 * (auto-sense) */
-
-	unsigned flags;
-
-	/* Low-level done function - can be used by low-level driver to point
-	 *        to completion function.  Not used by mid/upper level code. */
-	void (*scsi_done) (struct scsi_cmnd *);
-
-	/*
-	 * The following fields can be written to by the host specific code. 
-	 * Everything else should be left alone. 
-	 */
-
-	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
-
-	unsigned char *host_scribble;	/* The host adapter is allowed to
-					   * call scsi_malloc and get some memory
-					   * and hang it here.     The host adapter
-					   * is also expected to call scsi_free
-					   * to release this memory.  (The memory
-					   * obtained by scsi_malloc is guaranteed
-					   * to be at an address < 16Mb). */
-
-	int result;		/* Status code from lower level driver */
-
-	unsigned char tag;	/* SCSI-II queued command tag */
-	unsigned long pid;	/* Process ID, starts at 0 */
-};
-
-/*
  * Definitions and prototypes used for scsi mid-level queue.
  */
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
@@ -661,8 +377,6 @@
 	/* single command, look in space */
 	return sdev->current_cmnd;
 }
-
-int scsi_set_medium_removal(struct scsi_device *dev, char state);
 
 extern int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
 					    struct device_attribute *attr);
diff -Nru a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_cmnd.h	Sun Jun  8 19:19:25 2003
@@ -0,0 +1,164 @@
+#ifndef _SCSI_SCSI_CMND_H
+#define _SCSI_SCSI_CMND_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+struct request;
+struct scatterlist;
+struct scsi_device;
+struct scsi_request;
+
+
+/* embedded in scsi_cmnd */
+struct scsi_pointer {
+	char *ptr;		/* data pointer */
+	int this_residual;	/* left in this buffer */
+	struct scatterlist *buffer;	/* which buffer */
+	int buffers_residual;	/* how many buffers left */
+
+        dma_addr_t dma_handle;
+
+	volatile int Status;
+	volatile int Message;
+	volatile int have_data_in;
+	volatile int sent_command;
+	volatile int phase;
+};
+
+struct scsi_cmnd {
+	int     sc_magic;
+
+	struct scsi_device *device;
+	unsigned short state;
+	unsigned short owner;
+	struct scsi_request *sc_request;
+
+	struct list_head list;  /* scsi_cmnd participates in queue lists */
+
+	struct list_head eh_entry; /* entry for the host eh_cmd_q */
+	int eh_state;		/* Used for state tracking in error handlr */
+	int eh_eflags;		/* Used by error handlr */
+	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
+
+	/*
+	 * A SCSI Command is assigned a nonzero serial_number when internal_cmnd
+	 * passes it to the driver's queue command function.  The serial_number
+	 * is cleared when scsi_done is entered indicating that the command has
+	 * been completed.  If a timeout occurs, the serial number at the moment
+	 * of timeout is copied into serial_number_at_timeout.  By subsequently
+	 * comparing the serial_number and serial_number_at_timeout fields
+	 * during abort or reset processing, we can detect whether the command
+	 * has already completed.  This also detects cases where the command has
+	 * completed and the SCSI Command structure has already being reused
+	 * for another command, so that we can avoid incorrectly aborting or
+	 * resetting the new command.
+	 */
+	unsigned long serial_number;
+	unsigned long serial_number_at_timeout;
+
+	int retries;
+	int allowed;
+	int timeout_per_command;
+	int timeout_total;
+	int timeout;
+
+	/*
+	 * We handle the timeout differently if it happens when a reset, 
+	 * abort, etc are in process. 
+	 */
+	unsigned volatile char internal_timeout;
+
+	unsigned char cmd_len;
+	unsigned char old_cmd_len;
+	unsigned char sc_data_direction;
+	unsigned char sc_old_data_direction;
+
+	/* These elements define the operation we are about to perform */
+#define MAX_COMMAND_SIZE	16
+	unsigned char cmnd[MAX_COMMAND_SIZE];
+	unsigned request_bufflen;	/* Actual request size */
+
+	struct timer_list eh_timeout;	/* Used to time out the command. */
+	void *request_buffer;		/* Actual requested buffer */
+
+	/* These elements define the operation we ultimately want to perform */
+	unsigned char data_cmnd[MAX_COMMAND_SIZE];
+	unsigned short old_use_sg;	/* We save  use_sg here when requesting
+					 * sense info */
+	unsigned short use_sg;	/* Number of pieces of scatter-gather */
+	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
+	unsigned short abort_reason;	/* If the mid-level code requests an
+					 * abort, this is the reason. */
+	unsigned bufflen;	/* Size of data buffer */
+	void *buffer;		/* Data buffer */
+
+	unsigned underflow;	/* Return error if less than
+				   this amount is transferred */
+	unsigned old_underflow;	/* save underflow here when reusing the
+				 * command for error handling */
+
+	unsigned transfersize;	/* How much we are guaranteed to
+				   transfer with each SCSI transfer
+				   (ie, between disconnect / 
+				   reconnects.   Probably == sector
+				   size */
+
+	int resid;		/* Number of bytes requested to be
+				   transferred less actual number
+				   transferred (0 if not supported) */
+
+	struct request *request;	/* The command we are
+				   	   working on */
+
+#define SCSI_SENSE_BUFFERSIZE 	64
+	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
+						 * when CHECK CONDITION is
+						 * received on original command 
+						 * (auto-sense) */
+
+	unsigned flags;
+
+	/* Low-level done function - can be used by low-level driver to point
+	 *        to completion function.  Not used by mid/upper level code. */
+	void (*scsi_done) (struct scsi_cmnd *);
+
+	/*
+	 * The following fields can be written to by the host specific code. 
+	 * Everything else should be left alone. 
+	 */
+	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
+
+	unsigned char *host_scribble;	/* The host adapter is allowed to
+					   * call scsi_malloc and get some memory
+					   * and hang it here.     The host adapter
+					   * is also expected to call scsi_free
+					   * to release this memory.  (The memory
+					   * obtained by scsi_malloc is guaranteed
+					   * to be at an address < 16Mb). */
+
+	int result;		/* Status code from lower level driver */
+
+	unsigned char tag;	/* SCSI-II queued command tag */
+	unsigned long pid;	/* Process ID, starts at 0 */
+};
+
+/*
+ * These are the values that scsi_cmd->state can take.
+ */
+#define SCSI_STATE_TIMEOUT         0x1000
+#define SCSI_STATE_FINISHED        0x1001
+#define SCSI_STATE_FAILED          0x1002
+#define SCSI_STATE_QUEUED          0x1003
+#define SCSI_STATE_UNUSED          0x1006
+#define SCSI_STATE_DISCONNECTING   0x1008
+#define SCSI_STATE_INITIALIZING    0x1009
+#define SCSI_STATE_BHQUEUE         0x100a
+#define SCSI_STATE_MLQUEUE         0x100b
+
+
+extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, int);
+extern void scsi_put_command(struct scsi_cmnd *);
+extern void scsi_io_completion(struct scsi_cmnd *, int, int);
+
+#endif /* _SCSI_SCSI_CMND_H */
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_device.h	Sun Jun  8 19:19:25 2003
@@ -0,0 +1,106 @@
+#ifndef _SCSI_SCSI_DEVICE_H
+#define _SCSI_SCSI_DEVICE_H
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct request_queue;
+struct scsi_cmnd;
+
+
+struct scsi_device {
+	struct class_device	sdev_classdev;
+
+	struct list_head    siblings;   /* list of all devices on this host */
+	struct list_head    same_target_siblings; /* just the devices sharing same target id */
+	struct Scsi_Host *host;
+	struct request_queue *request_queue;
+	volatile unsigned short device_busy;	/* commands actually active on low-level */
+	spinlock_t sdev_lock;           /* also the request queue_lock */
+	spinlock_t list_lock;
+	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
+	struct list_head starved_entry;
+	struct scsi_cmnd *current_cmnd;	/* currently active command */
+	unsigned short queue_depth;	/* How deep of a queue we want */
+	unsigned short last_queue_full_depth; /* These two are used by */
+	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
+	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same
+					   jiffie count on our counter, they
+					   could all be from the same event. */
+
+	unsigned int id, lun, channel;
+
+	unsigned int manufacturer;	/* Manufacturer of device, for using 
+					 * vendor-specific cmd's */
+	unsigned sector_size;	/* size in bytes */
+
+	int access_count;	/* Count of open channels/mounts */
+
+	void *hostdata;		/* available to low-level driver */
+	char devfs_name[256];	/* devfs junk */
+	char type;
+	char scsi_level;
+	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
+	unsigned char * inquiry;	/* INQUIRY response data */
+	char * vendor;		/* [back_compat] point into 'inquiry' ... */
+	char * model;		/* ... after scan; point to static string */
+	char * rev;		/* ... "nullnullnullnull" before scan */
+	unsigned char current_tag;	/* current tag */
+	struct scsi_target      *sdev_target;   /* used only for single_lun */
+
+	unsigned online:1;
+
+	unsigned writeable:1;
+	unsigned removable:1;
+	unsigned changed:1;	/* Data invalid due to media change */
+	unsigned busy:1;	/* Used to prevent races */
+	unsigned lockable:1;	/* Able to prevent media removal */
+	unsigned locked:1;      /* Media removal disabled */
+	unsigned borken:1;	/* Tell the Seagate driver to be 
+				 * painfully slow on this device */
+	unsigned disconnect:1;	/* can disconnect */
+	unsigned soft_reset:1;	/* Uses soft reset option */
+	unsigned sdtr:1;	/* Device supports SDTR messages */
+	unsigned wdtr:1;	/* Device supports WDTR messages */
+	unsigned ppr:1;		/* Device supports PPR messages */
+	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
+	unsigned tagged_queue:1;/* This is going away!!!!  Look at simple_tags
+				   instead!!!  Please fix your driver now!! */
+	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
+	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */
+	unsigned single_lun:1;	/* Indicates we should only allow I/O to
+				 * one of the luns for the device at a 
+				 * time. */
+	unsigned was_reset:1;	/* There was a bus reset on the bus for 
+				 * this device */
+	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
+				     * because we did a bus reset. */
+	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
+	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned no_start_on_add:1;	/* do not issue start on add */
+
+	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
+
+	unsigned int max_device_blocked; /* what device_blocked counts down from  */
+#define SCSI_DEFAULT_DEVICE_BLOCKED	3
+
+	struct device sdev_driverfs_dev;
+};
+#define	to_scsi_device(d)	\
+	container_of(d, struct scsi_device, sdev_driverfs_dev)
+
+extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
+		uint, uint, uint);
+extern int scsi_remove_device(struct scsi_device *);
+extern void scsi_set_device_offline(struct scsi_device *);
+
+extern int scsi_device_get(struct scsi_device *);
+extern void scsi_device_put(struct scsi_device *);
+
+extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
+extern int scsi_track_queue_full(struct scsi_device *, int);
+
+extern int scsi_set_medium_removal(struct scsi_device *, char);
+
+#endif /* _SCSI_SCSI_DEVICE_H */
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/include/scsi/scsi_host.h	Sun Jun  8 19:19:25 2003
@@ -0,0 +1,539 @@
+#ifndef _SCSI_SCSI_HOST_H
+#define _SCSI_SCSI_HOST_H
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/types.h>
+
+struct block_device;
+struct module;
+struct scsi_cmnd;
+struct scsi_device;
+struct Scsi_Host;
+struct scsi_host_cmd_pool;
+
+
+/*
+ * The various choices mean:
+ * NONE: Self evident.	Host adapter is not capable of scatter-gather.
+ * ALL:	 Means that the host adapter module can do scatter-gather,
+ *	 and that there is no limit to the size of the table to which
+ *	 we scatter/gather data.
+ * Anything else:  Indicates the maximum number of chains that can be
+ *	 used in one scatter-gather request.
+ */
+#define SG_NONE 0
+#define SG_ALL 0xff
+
+
+#define DISABLE_CLUSTERING 0
+#define ENABLE_CLUSTERING 1
+
+
+struct scsi_host_template {
+	struct module *module;
+	const char *name;
+
+	/*
+	 * Used to initialize old-style drivers.  For new-style drivers
+	 * just perform all work in your module initialization function.
+	 *
+	 * Status:  OBSOLETE
+	 */
+	int (* detect)(struct scsi_host_template *);
+
+	/*
+	 * Used as unload callback for hosts with old-style drivers.
+	 *
+	 * Status: OBSOLETE
+	 */
+	int (* release)(struct Scsi_Host *);
+
+	/*
+	 * The info function will return whatever useful information the
+	 * developer sees fit.  If not provided, then the name field will
+	 * be used instead.
+	 *
+	 * Status: OPTIONAL
+	 */
+	const char *(* info)(struct Scsi_Host *);
+
+	/*
+	 * Ioctl interface
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* ioctl)(struct scsi_device *dev, int cmd, void *arg);
+	
+	/*
+	 * The queuecommand function is used to queue up a scsi
+	 * command block to the LLDD.  When the driver finished
+	 * processing the command the done callback is invoked.
+	 *
+	 * If queuecommand returns 0, then the HBA has accepted the
+	 * command.  The done() function must be called on the command
+	 * when the driver has finished with it. (you may call done on the
+	 * command before queuecommand returns, but in this case you
+	 * *must* return 0 from queuecommand).
+	 *
+	 * Queuecommand may also reject the command, in which case it may
+	 * not touch the command and must not call done() for it.
+	 *
+	 * There are two possible rejection returns:
+	 *
+	 *   SCSI_MLQUEUE_DEVICE_BUSY: Block this device temporarily, but
+	 *   allow commands to other devices serviced by this host.
+	 *
+	 *   SCSI_MLQUEUE_HOST_BUSY: Block all devices served by this
+	 *   host temporarily.
+	 *
+         * For compatibility, any other non-zero return is treated the
+         * same as SCSI_MLQUEUE_HOST_BUSY.
+	 *
+	 * NOTE: "temporarily" means either until the next command for#
+	 * this device/host completes, or a period of time determined by
+	 * I/O pressure in the system if there are no other outstanding
+	 * commands.
+	 *
+	 * STATUS: REQUIRED	(for exceptions see below)
+	 */
+	int (* queuecommand)(struct scsi_cmnd *,
+			     void (*done)(struct scsi_cmnd *));
+
+	/*
+	 * This is used instead of queuecommand if can_queue == 0;
+	 *
+	 * The return value has the following meaning:
+	 * Byte What:
+	 * 0    SCSI status code
+	 * 1    SCSI 1 byte message
+	 * 2    host error return.
+	 * 3    mid level error return
+	 *
+	 * Status: OBSOLETE
+	 */
+	int (* command)(struct scsi_cmnd *);
+
+	/*
+	 * This is an error handling strategy routine.  You don't need to
+	 * define one of these if you don't want to - there is a default
+	 * routine that is present that should work in most cases.  For those
+	 * driver authors that have the inclination and ability to write their
+	 * own strategy routine, this is where it is specified.  Note - the
+	 * strategy routine is *ALWAYS* run in the context of the kernel eh
+	 * thread.  Thus you are guaranteed to *NOT* be in an interrupt
+	 * handler when you execute this, and you are also guaranteed to
+	 * *NOT* have any other commands being queued while you are in the
+	 * strategy routine. When you return from this function, operations
+	 * return to normal.
+	 *
+	 * See scsi_error.c scsi_unjam_host for additional comments about
+	 * what this function should and should not be attempting to do.
+	 *
+	 * Status: REQUIRED	(at least one of them)
+	 */
+	int (* eh_strategy_handler)(struct Scsi_Host *);
+	int (* eh_abort_handler)(struct scsi_cmnd *);
+	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
+	int (* eh_host_reset_handler)(struct scsi_cmnd *);
+
+	/*
+	 * Old EH handlers, no longer used. Make them warn the user of old
+	 * drivers by using a wrong type
+	 *
+	 * Status: MORE THAN OBSOLETE
+	 */
+	int (* abort)(int);
+	int (* reset)(int, int);
+
+	/*
+	 * Before the mid layer attempts to scan for a new device where none
+	 * currently exists, it will call this entry in your driver.  Should
+	 * your driver need to allocate any structs or perform any other init
+	 * items in order to send commands to a currently unused target/lun
+	 * combo, then this is where you can perform those allocations.  This
+	 * is specifically so that drivers won't have to perform any kind of
+	 * "is this a new device" checks in their queuecommand routine,
+	 * thereby making the hot path a bit quicker.
+	 *
+	 * Return values: 0 on success, non-0 on failure
+	 *
+	 * Deallocation:  If we didn't find any devices at this ID, you will
+	 * get an immediate call to slave_destroy().  If we find something
+	 * here then you will get a call to slave_configure(), then the
+	 * device will be used for however long it is kept around, then when
+	 * the device is removed from the system (or * possibly at reboot
+	 * time), you will then get a call to slave_detach().  This is
+	 * assuming you implement slave_configure and slave_destroy.
+	 * However, if you allocate memory and hang it off the device struct,
+	 * then you must implement the slave_destroy() routine at a minimum
+	 * in order to avoid leaking memory
+	 * each time a device is tore down.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* slave_alloc)(struct scsi_device *);
+
+	/*
+	 * Once the device has responded to an INQUIRY and we know the
+	 * device is online, we call into the low level driver with the
+	 * struct scsi_device *.  If the low level device driver implements
+	 * this function, it *must* perform the task of setting the queue
+	 * depth on the device.  All other tasks are optional and depend
+	 * on what the driver supports and various implementation details.
+	 * 
+	 * Things currently recommended to be handled at this time include:
+	 *
+	 * 1.  Setting the device queue depth.  Proper setting of this is
+	 *     described in the comments for scsi_adjust_queue_depth.
+	 * 2.  Determining if the device supports the various synchronous
+	 *     negotiation protocols.  The device struct will already have
+	 *     responded to INQUIRY and the results of the standard items
+	 *     will have been shoved into the various device flag bits, eg.
+	 *     device->sdtr will be true if the device supports SDTR messages.
+	 * 3.  Allocating command structs that the device will need.
+	 * 4.  Setting the default timeout on this device (if needed).
+	 * 5.  Anything else the low level driver might want to do on a device
+	 *     specific setup basis...
+	 * 6.  Return 0 on success, non-0 on error.  The device will be marked
+	 *     as offline on error so that no access will occur.  If you return
+	 *     non-0, your slave_detach routine will never get called for this
+	 *     device, so don't leave any loose memory hanging around, clean
+	 *     up after yourself before returning non-0
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* slave_configure)(struct scsi_device *);
+
+	/*
+	 * Immediately prior to deallocating the device and after all activity
+	 * has ceased the mid layer calls this point so that the low level
+	 * driver may completely detach itself from the scsi device and vice
+	 * versa.  The low level driver is responsible for freeing any memory
+	 * it allocated in the slave_alloc or slave_configure calls. 
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* slave_destroy)(struct scsi_device *);
+
+	/*
+	 * This function determines the bios parameters for a given
+	 * harddisk.  These tend to be numbers that are made up by
+	 * the host adapter.  Parameters:
+	 * size, device, list (heads, sectors, cylinders)
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* bios_param)(struct scsi_device *, struct block_device *,
+			sector_t, int []);
+
+	/*
+	 * Can be used to export driver statistics and other infos to the
+	 * world outside the kernel ie. userspace and it also provides an
+	 * interface to feed the driver with information.
+	 *
+	 * Status: OBSOLETE
+	 */
+	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
+
+	/*
+	 * Name of proc directory
+	 */
+	char *proc_name;
+
+	/*
+	 * Used to store the procfs directory if a driver implements the
+	 * proc_info method.
+	 */
+	struct proc_dir_entry *proc_dir;
+
+	/*
+	 * This determines if we will use a non-interrupt driven
+	 * or an interrupt driven scheme,  It is set to the maximum number
+	 * of simultaneous commands a given host adapter will accept.
+	 */
+	int can_queue;
+
+	/*
+	 * In many instances, especially where disconnect / reconnect are
+	 * supported, our host also has an ID on the SCSI bus.  If this is
+	 * the case, then it must be reserved.  Please set this_id to -1 if
+	 * your setup is in single initiator mode, and the host lacks an
+	 * ID.
+	 */
+	int this_id;
+
+	/*
+	 * This determines the degree to which the host adapter is capable
+	 * of scatter-gather.
+	 */
+	unsigned short sg_tablesize;
+
+	/*
+	 * If the host adapter has limitations beside segment count
+	 */
+	unsigned short max_sectors;
+
+	/*
+	 * This specifies "machine infinity" for host templates which don't
+	 * limit the transfer size.  Note this limit represents an absolute
+	 * maximum, and may be over the transfer limits allowed for
+	 * individual devices (e.g. 256 for SCSI-1)
+	 */
+#define SCSI_DEFAULT_MAX_SECTORS	1024
+
+	/*
+	 * True if this host adapter can make good use of linked commands.
+	 * This will allow more than one command to be queued to a given
+	 * unit on a given host.  Set this to the maximum number of command
+	 * blocks to be provided for each device.  Set this to 1 for one
+	 * command block per lun, 2 for two, etc.  Do not set this to 0.
+	 * You should make sure that the host adapter will do the right thing
+	 * before you try setting this above 1.
+	 */
+	short cmd_per_lun;
+
+	/*
+	 * present contains counter indicating how many boards of this
+	 * type were found when we did the scan.
+	 */
+	unsigned char present;
+
+	/*
+	 * true if this host adapter uses unchecked DMA onto an ISA bus.
+	 */
+	unsigned unchecked_isa_dma:1;
+
+	/*
+	 * true if this host adapter can make good use of clustering.
+	 * I originally thought that if the tablesize was large that it
+	 * was a waste of CPU cycles to prepare a cluster list, but
+	 * it works out that the Buslogic is faster if you use a smaller
+	 * number of segments (i.e. use clustering).  I guess it is
+	 * inefficient.
+	 */
+	unsigned use_clustering:1;
+
+	/*
+	 * True for emulated SCSI host adapters (e.g. ATAPI)
+	 */
+	unsigned emulated:1;
+
+	unsigned highmem_io:1;
+
+	/* 
+	 * True if the driver wishes to use the generic block layer
+	 * tag queueing functions
+	 */
+	unsigned use_blk_tcq:1;
+
+	/*
+	 * Countdown for host blocking with no commands outstanding
+	 */
+	unsigned int max_host_blocked;
+
+	/*
+	 * Default value for the blocking.  If the queue is empty,
+	 * host_blocked counts down in the request_fn until it restarts
+	 * host operations as zero is reached.  
+	 *
+	 * FIXME: This should probably be a value in the template
+	 */
+#define SCSI_DEFAULT_HOST_BLOCKED	7
+
+	/*
+	 * Pointer to the sysfs class properties for this host
+	 */
+	struct class_device_attribute **shost_attrs;
+
+	/*
+	 * Pointer to the SCSI device properties for this host
+	 */
+	struct device_attribute **sdev_attrs;
+
+	/*
+	 * List of hosts per template.
+	 *
+	 * This is only for use by scsi_module.c for legacy templates.
+	 * For these access to it is synchronized implicitly by
+	 * module_init/module_exit.
+	 */
+	struct list_head legacy_hosts;
+};
+
+struct Scsi_Host {
+	struct list_head	my_devices;
+	struct scsi_host_cmd_pool *cmd_pool;
+	spinlock_t		free_list_lock;
+	struct list_head	free_list;   /* backup store of cmd structs */
+	struct list_head	starved_list;
+
+	spinlock_t		default_lock;
+	spinlock_t		*host_lock;
+
+	struct list_head	eh_cmd_q;
+	struct task_struct    * ehandler;  /* Error recovery thread. */
+	struct semaphore      * eh_wait;   /* The error recovery thread waits on
+                                          this. */
+	struct completion     * eh_notify; /* wait for eh to begin or end */
+	struct semaphore      * eh_action; /* Wait for specific actions on the
+                                          host. */
+	unsigned int            eh_active:1; /* Indicates the eh thread is awake and active if
+                                          this is true. */
+	unsigned int            eh_kill:1; /* set when killing the eh thread */
+	wait_queue_head_t       host_wait;
+	struct scsi_host_template *hostt;
+	volatile unsigned short host_busy;   /* commands actually active on low-level */
+	volatile unsigned short host_failed; /* commands that failed. */
+    
+	unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
+	int resetting; /* if set, it means that last_reset is a valid value */
+	unsigned long last_reset;
+
+	/*
+	 * These three parameters can be used to allow for wide scsi,
+	 * and for host adapters that support multiple busses
+	 * The first two should be set to 1 more than the actual max id
+	 * or lun (i.e. 8 for normal systems).
+	 */
+	unsigned int max_id;
+	unsigned int max_lun;
+	unsigned int max_channel;
+
+	/*
+	 * This is a unique identifier that must be assigned so that we
+	 * have some way of identifying each detected host adapter properly
+	 * and uniquely.  For hosts that do not support more than one card
+	 * in the system at one time, this does not need to be set.  It is
+	 * initialized to 0 in scsi_register.
+	 */
+	unsigned int unique_id;
+
+	/*
+	 * The maximum length of SCSI commands that this host can accept.
+	 * Probably 12 for most host adapters, but could be 16 for others.
+	 * For drivers that don't set this field, a value of 12 is
+	 * assumed.  I am leaving this as a number rather than a bit
+	 * because you never know what subsequent SCSI standards might do
+	 * (i.e. could there be a 20 byte or a 24-byte command a few years
+	 * down the road?).  
+	 */
+	unsigned char max_cmd_len;
+
+	int this_id;
+	int can_queue;
+	short cmd_per_lun;
+	short unsigned int sg_tablesize;
+	short unsigned int max_sectors;
+
+	unsigned in_recovery:1;
+	unsigned unchecked_isa_dma:1;
+	unsigned use_clustering:1;
+	unsigned highmem_io:1;
+	unsigned use_blk_tcq:1;
+
+	/*
+	 * Host has requested that no further requests come through for the
+	 * time being.
+	 */
+	unsigned host_self_blocked:1;
+    
+	/*
+	 * Host uses correct SCSI ordering not PC ordering. The bit is
+	 * set for the minority of drivers whose authors actually read
+	 * the spec ;)
+	 */
+	unsigned reverse_ordering:1;
+
+	/*
+	 * Host has rejected a command because it was busy.
+	 */
+	unsigned int host_blocked;
+
+	/*
+	 * Value host_blocked counts down from
+	 */
+	unsigned int max_host_blocked;
+
+	/* 
+	 * Support for sysfs
+	 */
+	struct device host_gendev;
+	struct class_device class_dev;
+
+	/* legacy crap */
+	unsigned long base;
+	unsigned long io_port;
+	unsigned char n_io_port;
+	unsigned char dma_channel;
+	unsigned int  irq;
+
+
+	/*
+	 * List of hosts per template.
+	 *
+	 * This is only for use by scsi_module.c for legacy templates.
+	 * For these access to it is synchronized implicitly by
+	 * module_init/module_exit.
+	 */
+	struct list_head sht_legacy_list;
+
+	/*
+	 * We should ensure that this is aligned, both for better performance
+	 * and also because some compilers (m68k) don't automatically force
+	 * alignment to a long boundary.
+	 */
+	unsigned long hostdata[0]  /* Used for storage of host specific stuff */
+		__attribute__ ((aligned (sizeof(unsigned long))));
+};
+#define		dev_to_shost(d)		\
+	container_of(d, struct Scsi_Host, host_gendev)
+#define		class_to_shost(d)	\
+	container_of(d, struct Scsi_Host, class_dev)
+
+extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
+extern int scsi_add_host(struct Scsi_Host *, struct device *);
+extern int scsi_remove_host(struct Scsi_Host *);
+extern void scsi_host_get(struct Scsi_Host *);
+extern void scsi_host_put(struct Scsi_Host *t);
+extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+
+extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
+
+static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
+{
+	shost->host_lock = lock;
+}
+
+static inline void scsi_set_device(struct Scsi_Host *shost,
+                                   struct device *dev)
+{
+        shost->host_gendev.parent = dev;
+}
+
+static inline struct device *scsi_get_device(struct Scsi_Host *shost)
+{
+        return shost->host_gendev.parent;
+}
+
+extern void scsi_sysfs_release_attributes(struct scsi_host_template *);
+
+extern void scsi_unblock_requests(struct Scsi_Host *);
+extern void scsi_block_requests(struct Scsi_Host *);
+
+/*
+ * These two functions are used to allocate and free a pseudo device
+ * which will connect to the host adapter itself rather than any
+ * physical device.  You must deallocate when you are done with the
+ * thing.  This physical pseudo-device isn't real and won't be available
+ * from any high-level drivers.
+ */
+extern void scsi_free_host_dev(struct scsi_device *);
+extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+
+/* legacy interfaces */
+extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
+extern void scsi_unregister(struct Scsi_Host *);
+
+#endif /* _SCSI_SCSI_HOST_H */
