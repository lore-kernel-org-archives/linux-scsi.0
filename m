From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] Documentation update: remove /etc/modules.conf refs
Date: Mon, 19 Jan 2004 17:57:40 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119065944.9A53A2C25B@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:50113 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264418AbUASG7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 01:59:48 -0500
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org, akpm@osdl.org
Cc: Claus-Justus Heine <claus@momo.math.rwth-aachen.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Jaroslav Kysela <perex@suse.cz>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Ralph Metzler <ralph@convergence.de>, Stelian Pop <stelian.pop@fr.alcove.com>, Takashi Iwai <tiwai@suse.de>, Wade Hampton <whampton@staffnet.com>, jgarzik@pobox.com, linux-scsi@vger.kernel.org, axboe@suse.de, tadavis@lbl.gov, zippel@linux-m68k.org

Name: Remove Obsolete References To modules.conf
Author: Rusty Russell
Status: Experimental
Depends: Module/module_more_aliases.patch.gz

D: Someone complained about the number of references to /etc/modules.conf
D: in the documentation.  While fixing them up (and examples where changed),
D: removed those which are redundant due to MODULE_ALIAS.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/Changes .24478-linux-2.6.1-bk4.updated/Documentation/Changes
--- .24478-linux-2.6.1-bk4/Documentation/Changes	2004-01-10 13:59:01.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/Changes	2004-01-19 16:34:27.000000000 +1100
@@ -216,13 +216,6 @@ chmod 0644 /dev/cpu/microcode
 as root before you can use this.  You'll probably also want to
 get the user-space microcode_ctl utility to use with this.
 
-If you have compiled the driver as a module you may need to add
-the following line:
-
-alias char-major-10-184 microcode
-
-to your /etc/modules.conf file.
-
 Powertweak
 ----------
 
@@ -257,17 +250,6 @@ mknod /dev/ppp c 108 0
 
 as root.
 
-If you build ppp support as modules, you will need the following in
-your /etc/modules.conf file:
-
-alias char-major-108	ppp_generic
-alias /dev/ppp		ppp_generic
-alias tty-ldisc-3	ppp_async
-alias tty-ldisc-14	ppp_synctty
-alias ppp-compress-21	bsd_comp
-alias ppp-compress-24	ppp_deflate
-alias ppp-compress-26	ppp_deflate
-
 If you use devfsd and build ppp support as modules, you will need
 the following in your /etc/devfsd.conf file:
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/computone.txt .24478-linux-2.6.1-bk4.updated/Documentation/computone.txt
--- .24478-linux-2.6.1-bk4/Documentation/computone.txt	2003-09-22 10:26:19.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/computone.txt	2004-01-19 17:39:06.000000000 +1100
@@ -41,11 +41,11 @@ Hardware - If you have an ISA card, find
 
 	Note the hardware address from the Computone ISA cards installed into
 		the system.  These are required for editing ip2.c or editing
-		/etc/modules.conf, or for specification on the modprobe
+		/etc/modprobe.conf, or for specification on the modprobe
 		command line.
 
-	Note that the /etc/modules.conf file is named /etc/conf.modules
-		with older versions of the module utilities.
+	Note that the /etc/modules.conf should be used for older (pre-2.6)
+		kernels.
 
 Software -
 
@@ -58,7 +58,7 @@ b) Run "make config" or "make menuconfig
 c) Set address on ISA cards then:
    edit /usr/src/linux/drivers/char/ip2.c if needed 
 	or
-   edit /etc/modules.conf if needed (module).
+   edit /etc/modprobe.conf if needed (module).
 	or both to match this setting.
 d) Run "make modules"
 e) Run "make modules_install"
@@ -145,11 +145,11 @@ the irqs are not specified the driver us
 selects polled mode). If no base addresses are specified the defaults in 
 ip2.c are used. If you are autoloading the driver module with kerneld or
 kmod the base addresses and interrupt number must also be set in ip2.c
-and recompile or just insert and options line in /etc/modules.conf or both. 
+and recompile or just insert and options line in /etc/modprobe.conf or both. 
 The options line is equivalent to the command line and takes precidence over 
 what is in ip2.c. 
 
-/etc/modules.conf sample:
+/etc/modprobe.conf sample:
 	options ip2 io=1,0x328 irq=1,10
 	alias char-major-71 ip2
 	alias char-major-72 ip2
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/crypto/api-intro.txt .24478-linux-2.6.1-bk4.updated/Documentation/crypto/api-intro.txt
--- .24478-linux-2.6.1-bk4/Documentation/crypto/api-intro.txt	2003-10-09 18:02:47.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/crypto/api-intro.txt	2004-01-19 17:39:20.000000000 +1100
@@ -68,7 +68,7 @@ Many real examples are available in the 
 CONFIGURATION NOTES
 
 As Triple DES is part of the DES module, for those using modular builds,
-add the following line to /etc/modules.conf:
+add the following line to /etc/modprobe.conf:
 
   alias des3_ede des
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/digiboard.txt .24478-linux-2.6.1-bk4.updated/Documentation/digiboard.txt
--- .24478-linux-2.6.1-bk4/Documentation/digiboard.txt	2000-08-29 15:23:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/digiboard.txt	2004-01-19 16:40:53.000000000 +1100
@@ -24,7 +24,7 @@ The driver can be built direct into the 
 The pcxx driver can be configured using the command line feature while
 loading the kernel with LILO or LOADLIN or, if built as a module,
 with arguments to insmod and modprobe or with parameters in
-/etc/modules.conf for modprobe and kerneld.
+/etc/modprobe.conf for modprobe and kerneld.
 
 After configuring the driver you need to create the device special files
 as described in "Device file creation:" below and set the appropriate
@@ -91,13 +91,13 @@ devices following that board, you can em
 
 The remaining board still uses ttyD8-ttyD15 and cud8-cud15.
 
-Example line for /etc/modules.conf for use with kerneld and as default
+Example line for /etc/modprobe.conf for use with kerneld and as default
 parameters for modprobe:
 
 options pcxx           io=0x200 numports=8
 
-For kerneld to work you will likely need to add these two lines to your
-/etc/modules.conf:
+For kmod to work you will likely need to add these two lines to your
+/etc/modprobe.conf:
 
 alias char-major-22    pcxx
 alias char-major-23    pcxx
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/fb/intel810.txt .24478-linux-2.6.1-bk4.updated/Documentation/fb/intel810.txt
--- .24478-linux-2.6.1-bk4/Documentation/fb/intel810.txt	2003-09-22 09:47:05.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/fb/intel810.txt	2004-01-19 17:37:52.000000000 +1100
@@ -194,7 +194,7 @@ Using the same setup as described above,
 	modprobe i810fb vram=2 xres=1024 bpp=8 hsync1=30 hsync2=55 vsync1=50 \
 	         vsync2=85 accel=1 mtrr=1
 
-Or just add the following to /etc/modules.conf
+Or just add the following to /etc/modprobe.conf
 
 	options i810fb vram=2 xres=1024 bpp=16 hsync1=30 hsync2=55 vsync1=50 \
 	vsync2=85 accel=1 mtrr=1
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/ftape.txt .24478-linux-2.6.1-bk4.updated/Documentation/ftape.txt
--- .24478-linux-2.6.1-bk4/Documentation/ftape.txt	2003-10-09 18:02:47.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/ftape.txt	2004-01-19 16:59:29.000000000 +1100
@@ -242,15 +242,15 @@ C. Boot and load time configuration
    Module parameters can be specified either directly when invoking
    the program 'insmod' at the shell prompt:
 
-   insmod ftape.o ft_tracing=4
+   modprobe ftape ft_tracing=4
 
-   or by editing the file `/etc/modules.conf' in which case they take
+   or by editing the file `/etc/modprobe.conf' in which case they take
    effect each time when the module is loaded with `modprobe' (please
    refer to the respective manual pages). Thus, you should add a line
 
    options ftape ft_tracing=4
 
-   to `/etc/modules.conf` if you intend to increase the debugging
+   to `/etc/modprobe.conf` if you intend to increase the debugging
    output of the driver.
 
 
@@ -298,7 +298,7 @@ C. Boot and load time configuration
 5. Example module parameter setting
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    To do the same, but with ftape compiled as a loadable kernel
-   module, add the following line to `/etc/modules.conf':
+   module, add the following line to `/etc/modprobe.conf':
 
    options ftape ft_probe_fc10=1 ft_tracing=4
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/hayes-esp.txt .24478-linux-2.6.1-bk4.updated/Documentation/hayes-esp.txt
--- .24478-linux-2.6.1-bk4/Documentation/hayes-esp.txt	1999-11-07 05:38:40.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/hayes-esp.txt	2004-01-19 16:59:00.000000000 +1100
@@ -109,7 +109,7 @@ option with a space.  For example:
 insmod esp dma=3 trigger=512
 
 The esp module can be automatically loaded when needed.  To cause this to
-happen, add the following lines to /etc/modules.conf (replacing the last line
+happen, add the following lines to /etc/modprobe.conf (replacing the last line
 with options for your configuration):
 
 alias char-major-57 esp
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/ide.txt .24478-linux-2.6.1-bk4.updated/Documentation/ide.txt
--- .24478-linux-2.6.1-bk4/Documentation/ide.txt	2003-10-23 10:02:44.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/ide.txt	2004-01-19 16:56:44.000000000 +1100
@@ -198,12 +198,11 @@ drivers can always be compiled as loadab
 can only be compiled into the kernel, and the core code (ide.c) can be
 compiled as a loadable module provided no chipset support is needed.
 
-When using ide.c/ide-tape.c as modules in combination with kerneld, add:
+When using ide.c as a module in combination with kmod, add:
 
 	alias block-major-3 ide-probe
-	alias char-major-37 ide-tape
 
-respectively to /etc/modules.conf.
+to /etc/modprobe.conf.
 
 When ide.c is used as a module, you can pass command line parameters to the
 driver using the "options=" keyword to insmod, while replacing any ',' with
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/baycom.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/baycom.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/baycom.txt	1999-11-07 05:38:40.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/baycom.txt	2004-01-19 16:20:00.000000000 +1100
@@ -93,10 +93,10 @@ Every time a driver is inserted into the
 modems it should access at which ports. This can be done with the setbaycom
 utility. If you are only using one modem, you can also configure the
 driver from the insmod command line (or by means of an option line in
-/etc/modules.conf).
+/etc/modprobe.conf).
 
 Examples:
-  insmod baycom_ser_fdx mode="ser12*" iobase=0x3f8 irq=4
+  modprobe baycom_ser_fdx mode="ser12*" iobase=0x3f8 irq=4
   sethdlc -i bcsf0 -p mode "ser12*" io 0x3f8 irq 4
 
 Both lines configure the first port to drive a ser12 modem at the first
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/bonding.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/bonding.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/bonding.txt	2003-09-29 10:25:14.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/bonding.txt	2004-01-19 16:29:22.000000000 +1100
@@ -73,13 +73,8 @@ To install ifenslave.c, do:
 Bond Configuration
 ==================
 
-You will need to add at least the following line to /etc/modules.conf
-so the bonding driver will automatically load when the bond0 interface is 
-configured. Refer to the modules.conf manual page for specific modules.conf 
-syntax details. The Module Parameters section of this document describes each 
-bonding driver parameter. 
-
-	alias bond0 bonding
+In Linux kernels 2.6 and above, the module creates its own "bond?" alias,
+so any access to eg. bond0 will load the bonding module.
 
 Use standard distribution techniques to define the bond0 network interface. For
 example, on modern Red Hat distributions, create an ifcfg-bond0 file in
@@ -132,10 +127,10 @@ You can then create a script containing 
 appropriate rc directory.
 
 If you specifically need all network drivers loaded before the bonding driver,
-adding the following line to modules.conf will cause the network driver for 
+adding the following line to modprobe.conf will cause the network driver for 
 eth0 and eth1 to be loaded before the bonding driver.
 
-probeall bond0 eth0 eth1 bonding
+install bond0 /sbin/modprobe -a eth0 eth1 && /sbin/modprobe bonding
 
 Be careful not to reference bond0 itself at the end of the line, or modprobe 
 will die in an endless recursive loop.
@@ -191,7 +186,7 @@ Module Parameters
 
 Optional parameters for the bonding driver can be supplied as command line 
 arguments to the insmod command. Typically, these parameters are specified in 
-the file /etc/modules.conf (see the manual page for modules.conf). The 
+the file /etc/modprobe.conf (see the manual page for modprobe.conf). The 
 available bonding driver parameters are listed below. If a parameter is not 
 specified the default value is used. When initially configuring a bond, it
 is recommended "tail -f /var/log/messages" be run in a separate window to
@@ -756,9 +751,8 @@ Example:
 
    # modprobe bonding miimon=100
 
-Or, put the following lines in /etc/modules.conf:
+Or, put the following line in /etc/modprobe.conf:
 
-   alias bond0 bonding
    options bond0 miimon=100
 
 There are currently two policies for high availability. They are dependent on 
@@ -829,9 +823,8 @@ To use this mode, pass "mode=1" to the m
 
     # modprobe bonding miimon=100 mode=1
 
-Or, put in your /etc/modules.conf :
+Or, put in your /etc/modprobe.conf :
 
-    alias bond0 bonding
     options bond0 miimon=100 mode=active-backup
 
 Example 1: Using multiple host and multiple switches to build a "no single
@@ -933,7 +926,6 @@ setting by hand. Specifically, when you 
 must add the promisc flag there; it will be propagated down to the
 slave interfaces at ifenslave time; a full example might look like:
 
-   grep bond0 /etc/modules.conf || echo alias bond0 bonding >/etc/modules.conf
    ifconfig bond0 promisc up
    for if in eth1 eth2 ...;do
        ifconfig $if up
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/dl2k.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/dl2k.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/dl2k.txt	2003-09-21 17:25:50.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/dl2k.txt	2004-01-19 16:23:57.000000000 +1100
@@ -37,15 +37,15 @@ Quick Install
 Install linux driver as following command:
 
 1. make all
-2. insmod dl2k.o
+2. insmod dl2k.ko
 3. ifconfig eth0 up 10.xxx.xxx.xxx netmask 255.0.0.0
 		    ^^^^^^^^^^^^^^^\	    ^^^^^^^^\
 				    IP		     NETMASK
 Now eth0 should active, you can test it by "ping" or get more information by
 "ifconfig". If tested ok, continue the next step.
 
-4. cp dl2k.o /lib/modules/`uname -r`/kernel/drivers/net
-5. Add the following lines to /etc/modules.conf:
+4. cp dl2k.ko /lib/modules/`uname -r`/kernel/drivers/net
+5. Add the following line to /etc/modprobe.conf:
 	alias eth0 dl2k
 6. Run "netconfig" or "netconf" to create configuration script ifcfg-eth0
    located at /etc/sysconfig/network-scripts or create it manually.
@@ -154,8 +154,8 @@ Installing the Driver
   -----------------
   1. Copy dl2k.o to the network modules directory, typically
      /lib/modules/2.x.x-xx/net or /lib/modules/2.x.x/kernel/drivers/net.
-  2. Locate the boot module configuration file, most commonly modules.conf
-     or conf.modules in the /etc directory. Add the following lines:
+  2. Locate the boot module configuration file, most commonly modprobe.conf
+     or modules.conf (for 2.4) in the /etc directory. Add the following lines:
 
      alias ethx dl2k
      options dl2k <optional parameters>
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/ltpc.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/ltpc.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/ltpc.txt	1999-11-07 05:38:40.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/ltpc.txt	2004-01-19 16:20:06.000000000 +1100
@@ -25,7 +25,7 @@ the driver will try to determine them it
 
 If you load the driver as a module, you can pass the parameters "io=",
 "irq=", and "dma=" on the command line with insmod or modprobe, or add
-them as options in /etc/modules.conf:
+them as options in /etc/modprobe.conf:
 
  alias lt0 ltpc # autoload the module when the interface is configured
  options ltpc io=0x240 irq=9 dma=1
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/sk98lin.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/sk98lin.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/sk98lin.txt	2004-01-17 15:35:22.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/sk98lin.txt	2004-01-19 16:20:58.000000000 +1100
@@ -174,7 +174,7 @@ In some distributions, the configuration
 to the driver module.
 
 If you use the kernel module loader, you can set driver parameters
-in the file /etc/modules.conf (or old name: /etc/conf.modules).
+in the file /etc/modprobe.conf (or /etc/modules.conf in 2.4 or earlier).
 To set the driver parameters in this file, proceed as follows:
 
 1. Insert a line of the form :
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/tuntap.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/tuntap.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/tuntap.txt	2003-09-22 10:05:44.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/tuntap.txt	2004-01-19 16:21:53.000000000 +1100
@@ -45,13 +45,10 @@ Copyright (C) 1999-2000 Maxim Krasnyansk
      bogus network interfaces to trick firewalls or administrators.
 
   Driver module autoloading
-     Make sure that "Kernel module loader" - module auto-loading support is enabled 
-     in your kernel. 
 
-     Add the following line to the /etc/modules.conf:
-	alias char-major-10-200 tun
-     and run
-        depmod -a 
+     Make sure that "Kernel module loader" - module auto-loading
+     support is enabled in your kernel.  The kernel should load it on
+     first access.
   
   Manual loading 
      insert the module by hand:
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/networking/vortex.txt .24478-linux-2.6.1-bk4.updated/Documentation/networking/vortex.txt
--- .24478-linux-2.6.1-bk4/Documentation/networking/vortex.txt	2003-09-22 10:26:19.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/networking/vortex.txt	2004-01-19 16:19:43.000000000 +1100
@@ -59,8 +59,8 @@ Module parameters
 =================
 
 There are several parameters which may be provided to the driver when
-its module is loaded.  These are usually placed in /etc/modules.conf
-(used to be conf.modules).  Example:
+its module is loaded.  These are usually placed in /etc/modprobe.conf
+(/etc/modules.conf in 2.4).  Example:
 
 options 3c59x debug=3 rx_copybreak=300
 
@@ -413,9 +413,9 @@ steps you should take:
 
       1) Increase the debug level.  Usually this is done via:
 
-         a) modprobe driver.o debug=7
-         b) In /etc/conf.modules (or modules.conf):
-            options driver_name debug=7
+         a) modprobe driver debug=7
+         b) In /etc/modprobe.conf (or /etc/modules.conf for 2.4):
+            options driver debug=7
 
       2) Recreate the problem with the higher debug level,
          send all logs to the maintainer.
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/parport.txt .24478-linux-2.6.1-bk4.updated/Documentation/parport.txt
--- .24478-linux-2.6.1-bk4/Documentation/parport.txt	2001-11-10 09:30:55.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/parport.txt	2004-01-19 16:57:51.000000000 +1100
@@ -39,7 +39,7 @@ are automatically detected.
 KMod
 ----
 
-If you use kmod, you will find it useful to edit /etc/modules.conf.
+If you use kmod, you will find it useful to edit /etc/modprobe.conf.
 Here is an example of the lines that need to be added:
 
 	alias parport_lowlevel parport_pc
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/rocket.txt .24478-linux-2.6.1-bk4.updated/Documentation/rocket.txt
--- .24478-linux-2.6.1-bk4/Documentation/rocket.txt	2003-09-22 10:08:48.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/rocket.txt	2004-01-19 17:39:57.000000000 +1100
@@ -43,7 +43,7 @@ in the system log at /var/log/messages.
 
 If installed as a module, the module must be loaded.  This can be done
 manually by entering "modprobe rocket".  To have the module loaded automatically
-upon system boot, edit the /etc/modules.conf file and add the line
+upon system boot, edit the /etc/modprobe.conf file and add the line
 "alias char-major-46 rocket".
 
 In order to use the ports, their device names (nodes) must be created with mknod.
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/s390/3270.txt .24478-linux-2.6.1-bk4.updated/Documentation/s390/3270.txt
--- .24478-linux-2.6.1-bk4/Documentation/s390/3270.txt	2003-09-22 10:26:19.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/s390/3270.txt	2004-01-19 16:59:53.000000000 +1100
@@ -48,7 +48,7 @@ one another.  ReIPL as soon as possible 
 script and the resulting /tmp/mkdev3270.
 
 If you have chosen to make tub3270 a module, you add a line to
-/etc/modules.conf.  If you are working on a VM virtual machine, you
+/etc/modprobe.conf.  If you are working on a VM virtual machine, you
 can use DEF GRAF to define virtual 3270 devices.
 
 You may generate both 3270 and 3215 console support, or one or the
@@ -60,7 +60,7 @@ at boot time to a 3270 if it is a 3215.
 
 In brief, these are the steps:
 	1. Install the tub3270 patch
-	2. (If a module) add a line to /etc/modules.conf
+	2. (If a module) add a line to /etc/modprobe.conf
 	3. (If VM) define devices with DEF GRAF
 	4. Reboot
 	5. Configure
@@ -84,13 +84,13 @@ Here are the installation steps in detai
 		make modules_install
 
 	2. (Perform this step only if you have configured tub3270 as a
-	module.)  Add a line to /etc/modules.conf to automatically
+	module.)  Add a line to /etc/modprobe.conf to automatically
 	load the driver when it's needed.  With this line added,
 	you will see login prompts appear on your 3270s as soon as
 	boot is complete (or with emulated 3270s, as soon as you dial
 	into your vm guest using the command "DIAL <vmguestname>").
 	Since the line-mode major number is 227, the line to add to
-	/etc/modules.conf should be:
+	/etc/modprobe.conf should be:
 		alias char-major-227 tub3270
 
 	3. Define graphic devices to your vm guest machine, if you
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/scsi/aic79xx.txt .24478-linux-2.6.1-bk4.updated/Documentation/scsi/aic79xx.txt
--- .24478-linux-2.6.1-bk4/Documentation/scsi/aic79xx.txt	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/scsi/aic79xx.txt	2004-01-19 17:39:52.000000000 +1100
@@ -210,7 +210,7 @@ The following information is available i
                  INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
                  USE THEM WITH CAUTION. 
 
-   Edit the file "modules.conf" in the directory /etc and add/edit a
+   Edit the file "modprobe.conf" in the directory /etc and add/edit a
    line containing 'options aic79xx aic79xx=[command[,command...]]' where
    'command' is one or more of the following:
    -----------------------------------------------------------------
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/scsi/aic7xxx.txt .24478-linux-2.6.1-bk4.updated/Documentation/scsi/aic7xxx.txt
--- .24478-linux-2.6.1-bk4/Documentation/scsi/aic7xxx.txt	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/scsi/aic7xxx.txt	2004-01-19 17:39:24.000000000 +1100
@@ -186,7 +186,7 @@ The following information is available i
                  INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
                  USE THEM WITH CAUTION. 
 
-   Edit the file "modules.conf" in the directory /etc and add/edit a
+   Edit the file "modprobe.conf" in the directory /etc and add/edit a
    line containing 'options aic7xxx aic7xxx=[command[,command...]]' where
    'command' is one or more of the following:
    -----------------------------------------------------------------
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/scsi/osst.txt .24478-linux-2.6.1-bk4.updated/Documentation/scsi/osst.txt
--- .24478-linux-2.6.1-bk4/Documentation/scsi/osst.txt	2003-09-21 17:31:51.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/scsi/osst.txt	2004-01-19 17:39:43.000000000 +1100
@@ -67,7 +67,7 @@ recognized.
 If you want to have the module autoloaded on access to /dev/osst, you may
 add something like
 alias char-major-206 osst
-to your /etc/modules.conf (old name: conf.modules).
+to your /etc/modprobe.conf (before 2.6: modules.conf).
 
 You may find it convenient to create a symbolic link 
 ln -s nosst0 /dev/tape
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sonypi.txt .24478-linux-2.6.1-bk4.updated/Documentation/sonypi.txt
--- .24478-linux-2.6.1-bk4/Documentation/sonypi.txt	2003-09-22 10:27:54.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sonypi.txt	2004-01-19 16:57:36.000000000 +1100
@@ -43,7 +43,7 @@ Driver options:
 ---------------
 
 Several options can be passed to the sonypi driver, either by adding them
-to /etc/modules.conf file, when the driver is compiled as a module or by
+to /etc/modprobe.conf file, when the driver is compiled as a module or by
 adding the following to the kernel command line (in your bootloader):
 
 	sonypi=minor[,verbose[,fnkeyinit[,camera[,compat[,mask[,useinput]]]]]]
@@ -109,7 +109,7 @@ Module use:
 -----------
 
 In order to automatically load the sonypi module on use, you can put those
-lines in your /etc/modules.conf file:
+lines in your /etc/modprobe.conf file:
 
 	alias char-major-10-250 sonypi
 	options sonypi minor=250
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/alsa/ALSA-Configuration.txt .24478-linux-2.6.1-bk4.updated/Documentation/sound/alsa/ALSA-Configuration.txt
--- .24478-linux-2.6.1-bk4/Documentation/sound/alsa/ALSA-Configuration.txt	2003-09-29 10:25:14.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/alsa/ALSA-Configuration.txt	2004-01-19 17:25:22.000000000 +1100
@@ -1042,9 +1042,9 @@ Module parameters
 
     For loading the firmware, use vxloader utility in alsa-tools
     package.  You can load the firmware automatically by adding
-    the following to /etc/modules.conf
+    the following to /etc/modprobe.conf
 
-	post-install snd-vx222 "/usr/bin/vxload"
+	install snd-vx222 /sbin/modprobe --first-time -i snd-vx222 && /usr/bin/vxload
 
     IBL size defines the interrupts period for PCM.  The smaller size
     gives smaller latency but leads to more CPU consumption, too.
@@ -1131,24 +1131,9 @@ modprobe/kmod support
 
 The modprobe program must know which modules are used for the
 device major numbers.
-Native ALSA devices have got default number 116. Thus a line like
-'alias char-major-116 snd' must be added to /etc/modules.conf. If you have 
-compiled the ALSA driver with the OSS/Free emulation code, then you
-will need to add lines as explained below:
 
-The ALSA driver uses soundcore multiplexer for 2.2+ kernels and OSS compatible
-devices. You should add line like 'alias char-major-14 soundcore'.
-
-Example with OSS/Free emulation turned on:
-
------ /etc/modules.conf
-
-# ALSA portion
-alias char-major-116 snd
-# OSS/Free portion
-alias char-major-14 soundcore
-
------ /etc/modules.conf
+Native ALSA devices have got default major number 116, and they have
+that module alias built-in, as well as 14 for OSS compatible devices.
 
 After the main multiplexer is loaded, its code requests top-level soundcard
 module. String 'snd-card-%i' is requested for native devices where %i is
@@ -1156,16 +1141,16 @@ soundcard number from zero to seven. Str
 for native devices where %i is slot number (for ALSA owner this means soundcard
 number).
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 # ALSA portion
 alias snd-card-0 snd-interwave
 alias snd-card-1 snd-ens1371
 # OSS/Free portion
-alias sound-slot-0 snd-card-0
-alias sound-slot-1 snd-card-1
+alias sound-slot-0 snd-interwave
+alias sound-slot-1 snd-ens1371
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 We are finished at this point with the configuration for ALSA native devices,
 but you may also need autoloading for ALSA's add-on OSS/Free emulation
@@ -1174,7 +1159,7 @@ must be loaded separately - snd-pcm-oss.
 is requested for OSS/Free service where first %i means slot number
 (e.g. card number) and second %i means service number.
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 # OSS/Free portion - card #1
 alias sound-service-0-0 snd-mixer-oss
@@ -1187,24 +1172,22 @@ alias sound-service-1-0 snd-mixer-oss
 alias sound-service-1-3 snd-pcm-oss
 alias sound-service-1-12 snd-pcm-oss
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 A complete example for Gravis UltraSound PnP soundcard:
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 # ISA PnP support (don't use IRQs 9,10,11,12,13)
 options isapnp isapnp_reserve_irq=9,10,11,12,13
 
 # ALSA native device support
-alias char-major-116 snd
-options snd major=116 cards_limit=1
+options snd cards_limit=1
 alias snd-card-0 snd-interwave
 options snd-interwave index=0 id="GusPnP"
 
 # OSS/Free setup
-alias char-major-14 soundcore
-alias sound-slot-0 snd-card-0
+alias sound-slot-0 snd-interwave
 alias sound-service-0-0 snd-mixer-oss
 alias sound-service-0-1 snd-seq-oss
 alias sound-service-0-3 snd-pcm-oss
@@ -1216,15 +1199,14 @@ alias sound-service-0-12 snd-pcm-oss
 A complete example if you want to use more soundcards in one machine
 (the configuration below is for Sound Blaster 16 and Gravis UltraSound Classic):
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 # ISA PnP support (don't use IRQs 9,10,11,12,13)
 # it's only an example to reserve some IRQs for another hardware
 options isapnp isapnp_reserve_irq=9,10,11,12,13
 
 # ALSA native device support
-alias char-major-116 snd
-options snd major=116 cards_limit=2
+options snd cards_limit=2
 alias snd-card-0 snd-gusclassic
 alias snd-card-1 snd-sb16
 options snd-gusclassic index=0 id="Gus" \
@@ -1232,14 +1214,13 @@ options snd-gusclassic index=0 id="Gus" 
 options snd-sb16 index=1 id="SB16"
 
 # OSS/Free setup
-alias char-major-14 soundcore
-alias sound-slot-0 snd-card-0
+alias sound-slot-0 snd-gusclassic
 alias sound-service-0-0 snd-mixer-oss
 alias sound-service-0-1 snd-seq-oss
 alias sound-service-0-3 snd-pcm-oss
 alias sound-service-0-8 snd-seq-oss
 alias sound-service-0-12 snd-pcm-oss
-alias sound-slot-1 snd-card-1
+alias sound-slot-1 snd-sb16
 alias sound-service-1-0 snd-mixer-oss
 alias sound-service-1-3 snd-pcm-oss
 alias sound-service-1-12 snd-pcm-oss
@@ -1249,25 +1230,23 @@ alias sound-service-1-12 snd-pcm-oss
 A complete example, two Gravis UltraSound Classic soundcards are installed
 in the system:
 
------ /etc/modules.conf
+----- /etc/modprobe.conf
 
 # ALSA native device support
-alias char-major-116 snd
-options snd major=116 cards_limit=2
+options snd cards_limit=2
 alias snd-card-0 snd-gusclassic
 alias snd-card-1 snd-gusclassic
 options snd-gusclassic index=0,1 id="Gus1","Gus2" \
         port=0x220,0x240 irq=5,7 dma1=1,5 dma2=3,6
 
 # OSS/Free setup
-alias char-major-14 soundcore
-alias sound-slot-0 snd-card-0
+alias sound-slot-0 snd-gusclassic
 alias sound-service-0-0 snd-mixer-oss
 alias sound-service-0-1 snd-seq-oss
 alias sound-service-0-3 snd-pcm-oss
 alias sound-service-0-8 snd-seq-oss
 alias sound-service-0-12 snd-pcm-oss
-alias sound-slot-1 snd-card-1
+alias sound-slot-1 snd-gusclassic
 alias sound-service-1-0 snd-mixer-oss
 alias sound-service-1-3 snd-pcm-oss
 alias sound-service-1-12 snd-pcm-oss
@@ -1277,7 +1256,7 @@ alias sound-service-1-12 snd-pcm-oss
 If you want to autoclean your modules, you should put below line to your
 /etc/crontab:
 
-*/10 * * * *   root  /sbin/modprobe -rs snd-card-0 snd-card-1; /sbin/rmmod -as
+*/10 * * * *   root  /sbin/modprobe -rs snd-card-0 snd-card-1
 
 You may also want to extend the soundcard list to follow your requirements.
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/alsa/OSS-Emulation.txt .24478-linux-2.6.1-bk4.updated/Documentation/sound/alsa/OSS-Emulation.txt
--- .24478-linux-2.6.1-bk4/Documentation/sound/alsa/OSS-Emulation.txt	2003-09-29 10:25:14.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/alsa/OSS-Emulation.txt	2004-01-19 17:25:35.000000000 +1100
@@ -14,7 +14,7 @@ When you need to access the OSS PCM, mix
 corresponding module has to be loaded.
 
 For loading these modules automatically, define the aliases in
-/etc/modules.conf like below:
+/etc/modprobe.conf like below:
 
 	alias sound-service-0-0 snd-mixer-oss
 	alias sound-service-0-1 snd-seq-oss
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/AWE32 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/AWE32
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/AWE32	2003-09-21 17:22:24.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/AWE32	2004-01-19 17:26:30.000000000 +1100
@@ -47,12 +47,12 @@ SB32.
 
    Copy it to a directory of your choice, and unpack it there.
 
-4) Edit /etc/modules.conf, and insert the following lines at the end of the
+4) Edit /etc/modprobe.conf, and insert the following lines at the end of the
    file:
 
   alias sound-slot-0 sb
   alias sound-service-0-1 awe_wave
-  post-install awe_wave /usr/local/bin/sfxload PATH_TO_SOUND_BANK_FILE
+  install awe_wave /sbin/modprobe --first-time -i awe_wave && /usr/local/bin/sfxload PATH_TO_SOUND_BANK_FILE
 
   You will of course have to change "PATH_TO_SOUND_BANK_FILE" to the full
   path of of the sound bank file. That will enable the Sound Blaster and AWE
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/AudioExcelDSP16 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/AudioExcelDSP16
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/AudioExcelDSP16	2003-09-21 17:23:05.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/AudioExcelDSP16	2004-01-19 17:27:55.000000000 +1100
@@ -41,7 +41,7 @@ mpu_base	I/O base address for activate M
 		(0x300, 0x310, 0x320 or 0x330)
 mpu_irq		MPU-401 irq line (5, 7, 9, 10 or 0)
 
-The /etc/modules.conf will have lines like this:
+The /etc/modprobe.conf will have lines like this:
 
 options opl3 io=0x388
 options ad1848 io=0x530 irq=11 dma=3
@@ -51,11 +51,11 @@ Where the aedsp16 options are the option
 ad1848 are the corresponding options for the MSS and OPL3 modules.
 
 Loading MSS and OPL3 needs to pre load the aedsp16 module to set up correctly
-the sound card. Installation dependencies must be written in the modules.conf
+the sound card. Installation dependencies must be written in the modprobe.conf
 file:
 
-pre-install ad1848 modprobe aedsp16
-pre-install opl3 modprobe aedsp16
+install ad1848 /sbin/modprobe aedsp16 && /sbin/modprobe -i ad1848
+install opl3 /sbin/modprobe aedsp16 && /sbin/modprobe -i opl3
 
 Then you must load the sound modules stack in this order:
 sound -> aedsp16 -> [ ad1848, opl3 ]
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/CMI8330 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/CMI8330
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/CMI8330	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/CMI8330	2004-01-19 17:28:14.000000000 +1100
@@ -143,7 +143,7 @@ CONFIG_SOUND_MSS=m
 
 
 
-Alma Chao <elysian@ethereal.torsion.org> suggests the following /etc/modules.conf:
+Alma Chao <elysian@ethereal.torsion.org> suggests the following /etc/modprobe.conf:
 
 alias sound ad1848
 alias synth0 opl3
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/Introduction .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Introduction
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/Introduction	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Introduction	2004-01-19 17:28:57.000000000 +1100
@@ -168,7 +168,7 @@ MODPROBE:
 =========
 
 If loading via modprobe, these common files are automatically loaded 
-when requested by modprobe.  For example, my /etc/modules.conf contains:
+when requested by modprobe.  For example, my /etc/modprobe.conf contains:
 
 alias sound sb 
 options sb io=0x240 irq=9 dma=3 dma16=5 mpu_io=0x300
@@ -228,7 +228,7 @@ http://www.opensound.com.  Before loadin
 driver, you should do the following:
 
 1.  remove sound modules (detailed above)
-2.  remove the sound modules from /etc/modules.conf
+2.  remove the sound modules from /etc/modprobe.conf
 3.  move the sound modules from /lib/modules/<kernel>/misc
     (for example, I make a /lib/modules/<kernel>/misc/tmp
     directory and copy the sound module files to that 
@@ -265,7 +265,7 @@ twice, you need to do the following:
     sb.o could be copied (or symlinked) to sb1.o for the
     second SoundBlaster.
 
-2.  Make a second entry in /etc/modules.conf, for example,
+2.  Make a second entry in /etc/modprobe.conf, for example,
     sound1 or sb1.  This second entry should refer to the
     new module names for example sb1, and should include
     the I/O, etc. for the second sound card.
@@ -369,7 +369,7 @@ There are several ways of configuring yo
 2)  On the command line when using insmod or in a bash script
     using command line calls to load sound.
 
-3)  In /etc/modules.conf when using modprobe.
+3)  In /etc/modprobe.conf when using modprobe.
 
 4)  Via Red Hat's GPL'd /usr/sbin/sndconfig program (text based).
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/MAD16 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/MAD16
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/MAD16	2003-09-21 17:22:24.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/MAD16	2004-01-19 17:29:39.000000000 +1100
@@ -1,4 +1,5 @@
-(This recipe has been edited to update the configuration symbols.)
+(This recipe has been edited to update the configuration symbols,
+ and change over to modprobe.conf for 2.6)
 
 From: Shaw Carruthers <shaw@shawc.demon.co.uk>
 
@@ -20,9 +21,9 @@ CONFIG_SOUND_ADLIB=m
 CONFIG_SOUND_MAD16=m
 CONFIG_SOUND_YM3812=m
 
-modules.conf has:
+modprobe.conf has:
 
-alias char-major-14 mad16
+alias char-major-14-* mad16
 options sb mad16=1
 options mad16 io=0x530 irq=7 dma=0 dma16=1  && /usr/local/bin/aumix -w 15 -p 20 -m 0 -1 0 -2 0 -3 0 -i 0
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/Maestro3 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Maestro3
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/Maestro3	2003-09-21 17:29:21.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Maestro3	2004-01-19 17:30:00.000000000 +1100
@@ -64,7 +64,7 @@ It may be modular or statically linked. 
 installed with the rest of the modules for the kernel on the system.
 Typically this will be in /lib/modules/ somewhere.  'alias sound-slot-0
 maestro3' should also be added to your module configs (typically
-/etc/modules.conf) if you're using modular OSS/Lite sound and want to
+/etc/modprobe.conf) if you're using modular OSS/Lite sound and want to
 default to using a maestro3 chip.
 
 There are very few options to the driver.  One is 'debug' which will 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/OPL3-SA2 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/OPL3-SA2
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/OPL3-SA2	2003-09-21 17:22:24.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/OPL3-SA2	2004-01-19 17:30:10.000000000 +1100
@@ -162,7 +162,7 @@ modprobe opl3sa2 io=0x370 mss_io=0x530 m
 modprobe opl3 io=0x388
 
 See the section "Automatic Module Loading" below for how to set up
-/etc/modules.conf to automate this.
+/etc/modprobe.conf to automate this.
 
 An important thing to remember that the opl3sa2 module's io argument is
 for it's own control port, which handles the card's master mixer for
@@ -196,7 +196,7 @@ Automatic Module Loading
 
 Lastly, if you're using modules and want to set up automatic module
 loading with kmod, the kernel module loader, here is the section I
-currently use in my modules.conf file:
+currently use in my modprobe.conf file:
 
 # Sound
 alias sound-slot-0 opl3sa2
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/Opti .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Opti
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/Opti	2003-09-21 17:22:24.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Opti	2004-01-19 17:31:00.000000000 +1100
@@ -18,7 +18,7 @@ force the card into a mode in which it c
 If you have another OS installed on your computer it is recommended
 that Linux and the other OS use the same resources.
 
-Also, it is recommended that resources specified in /etc/modules.conf
+Also, it is recommended that resources specified in /etc/modprobe.conf
 and resources specified in /etc/isapnp.conf agree.
 
 Compiling the sound driver
@@ -68,9 +68,9 @@ address is hard-coded into the driver.
 Using kmod and autoloading the sound driver
 -------------------------------------------
 Comment: as of linux-2.1.90 kmod is replacing kerneld.
-The config file '/etc/modules.conf' is used as before.
+The config file '/etc/modprobe.conf' is used as before.
 
-This is the sound part of my /etc/modules.conf file.
+This is the sound part of my /etc/modprobe.conf file.
 Following that I will explain each line.
 
 alias mixer0 mad16
@@ -80,7 +80,7 @@ alias synth0 opl3
 options sb mad16=1
 options mad16 irq=10 dma=0 dma16=1 io=0x530 joystick=1 cdtype=0
 options opl3 io=0x388
-post-install mad16 /sbin/ad1848_mixer_reroute 14 8 15 3 16 6
+install mad16 /sbin/modprobe -i mad16 && /sbin/ad1848_mixer_reroute 14 8 15 3 16 6
 
 If you have an MPU daughtercard or onboard MPU you will want to add to the
 "options mad16" line - eg 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/PAS16 .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/PAS16
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/PAS16	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/PAS16	2004-01-19 17:31:14.000000000 +1100
@@ -129,7 +129,7 @@ CONFIG_SOUND_YM3812
   You can then get OPL3 functionality by issuing the command:
   insmod opl3
   In addition, you must either add the following line to 
-  /etc/modules.conf:
+  /etc/modprobe.conf:
   options opl3 io=0x388
   or else add the following line to /etc/lilo.conf:
   opl3=0x388
@@ -159,5 +159,5 @@ following line would be appropriate:
 append="pas2=0x388,10,3,-1,0,-1,-1,-1 opl3=0x388"
 
 If sound is built totally modular, the above options may be 
-specified in /etc/modules.conf for pas2.o, sb.o and opl3.o 
+specified in /etc/modprobe.conf for pas2, sb and opl3 
 respectively. 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/README.modules .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/README.modules
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/README.modules	2003-09-21 17:22:24.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/README.modules	2004-01-19 17:34:14.000000000 +1100
@@ -26,10 +26,10 @@ Note that it is no longer necessary or p
 drivers/sound dir. Now one simply configures and makes one's kernel and
 modules in the usual way.
 
- Then, add to your /etc/modules.conf something like:
+ Then, add to your /etc/modprobe.conf something like:
 
-alias char-major-14 sb
-post-install sb /sbin/modprobe "-k" "adlib_card"
+alias char-major-14-* sb
+install sb /sbin/modprobe -i sb && /sbin/modprobe adlib_card
 options sb io=0x220 irq=7 dma=1 dma16=5 mpu_io=0x330
 options adlib_card io=0x388     # FM synthesizer
 
@@ -65,12 +65,12 @@ at the init_module() code for the card t
  Note that at present there is no way to configure the io, irq and other
 parameters for the modular drivers as one does for the wired drivers.. One
 needs to pass the modules the necessary parameters as arguments, either
-with /etc/modules.conf or with command-line args to modprobe, e.g.
+with /etc/modprobe.conf or with command-line args to modprobe, e.g.
 
-modprobe -k sb io=0x220 irq=7 dma=1 dma16=5 mpu_io=0x330
-modprobe -k adlib_card io=0x388
+modprobe sb io=0x220 irq=7 dma=1 dma16=5 mpu_io=0x330
+modprobe adlib_card io=0x388
 
- recommend using /etc/modules.conf.
+ recommend using /etc/modprobe.conf.
 
 Persistent DMA Buffers:
 
@@ -88,7 +88,7 @@ wasteful of RAM, but it guarantees that 
 
 To make the sound driver use persistent DMA buffers we need to pass the
 sound.o module a "dmabuf=1" command-line argument. This is normally done
-in /etc/modules.conf like so:
+in /etc/modprobe.conf like so:
 
 options sound		dmabuf=1
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/sound/oss/Wavefront .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Wavefront
--- .24478-linux-2.6.1-bk4/Documentation/sound/oss/Wavefront	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/sound/oss/Wavefront	2004-01-19 17:34:00.000000000 +1100
@@ -189,16 +189,15 @@ Here's my autoconf.h SOUND section:
 6) How do I configure my card ?
 ************************************************************
 
-You need to edit /etc/modules.conf. Here's mine (edited to show the
+You need to edit /etc/modprobe.conf. Here's mine (edited to show the
 relevant details):
 
   # Sound system
-  alias char-major-14 wavefront
+  alias char-major-14-* wavefront
   alias synth0 wavefront
   alias mixer0 cs4232
   alias audio0 cs4232
-  pre-install wavefront modprobe "-k" "cs4232"
-  post-install wavefront modprobe "-k" "opl3"
+  install wavefront /sbin/modprobe cs4232 && /sbin/modprobe -i wavefront && /sbin/modprobe opl3
   options wavefront io=0x200 irq=9
   options cs4232 synthirq=9 synthio=0x200 io=0x530 irq=5 dma=1 dma2=0
   options opl3 io=0x388
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/usb/scanner.txt .24478-linux-2.6.1-bk4.updated/Documentation/usb/scanner.txt
--- .24478-linux-2.6.1-bk4/Documentation/usb/scanner.txt	2003-09-22 10:05:44.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/usb/scanner.txt	2004-01-19 17:39:15.000000000 +1100
@@ -146,14 +146,14 @@ options to the driver.  Simply add 
 
   options scanner vendor=0x#### product=0x****
 
-to the /etc/modules.conf file replacing the #'s and the *'s with the
+to the /etc/modprobe.conf file replacing the #'s and the *'s with the
 correct IDs.  The IDs can be retrieved from the messages file or
 using "cat /proc/bus/usb/devices".
 
 If the default timeout is too low, i.e. there are frequent "timeout" messages,
 you may want to increase the timeout manually by using the parameter
 "read_timeout".  The time is given in seconds.  This is an example for
-modules.conf with a timeout of 60 seconds:
+modprobe.conf with a timeout of 60 seconds:
 
   options scanner read_timeout=60
  
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/CQcam.txt .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/CQcam.txt
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/CQcam.txt	2003-10-09 18:02:47.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/CQcam.txt	2004-01-19 17:37:39.000000000 +1100
@@ -62,7 +62,7 @@ But that is my personal preference.
  
   The configuration requires module configuration and device
 configuration.  I like kmod or kerneld process with the
-/etc/modules.conf file so the modules can automatically load/unload as
+/etc/modprobe.conf file so the modules can automatically load/unload as
 they are used.  The video devices could already exist, be generated
 using MAKEDEV, or need to be created.  The following sections detail
 these procedures.
@@ -71,15 +71,15 @@ these procedures.
 2.1 Module Configuration  
 
   Using modules requires a bit of work to install and pass the
-parameters.  Understand that entries in /etc/modules.conf of:
+parameters.  Understand that entries in /etc/modprobe.conf of:
 
    alias parport_lowlevel parport_pc
    options parport_pc io=0x378 irq=none
    alias char-major-81 videodev
    alias char-major-81-0 c-qcam
 
-will cause the kmod/kerneld/modprobe to do certain things.  If you are
-using kmod or kerneld, then a request for a 'char-major-81-0' will cause
+will cause the kmod/modprobe to do certain things.  If you are
+using kmod, then a request for a 'char-major-81-0' will cause
 the 'c-qcam' module to load.  If you have other video sources with
 modules, you might want to assign the different minor numbers to
 different modules.
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/Zoran .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/Zoran
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/Zoran	2003-09-29 10:25:14.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/Zoran	2004-01-19 17:37:47.000000000 +1100
@@ -233,7 +233,7 @@ Load zr36067.o. If it can't autodetect y
 option with X being the card number as given in the previous section.
 To have more than one card, use card=X1[,X2[,X3,[X4[..]]]]
 
-To automate this, add the following to your /etc/modules.conf:
+To automate this, add the following to your /etc/modprobe.conf:
 
 options zr36067 card=X1[,X2[,X3[,X4[..]]]]
 alias char-major-81-0 zr36067
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/Modprobe.conf .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/Modprobe.conf
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/Modprobe.conf	1970-01-01 10:00:00.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/Modprobe.conf	2004-01-19 17:35:17.000000000 +1100
@@ -0,0 +1,11 @@
+# i2c
+alias char-major-89	i2c-dev
+options i2c-core	i2c_debug=1
+options i2c-algo-bit	bit_test=1
+
+# bttv
+alias char-major-81	videodev
+alias char-major-81-0	bttv
+options	bttv		card=2 radio=1
+options	tuner		debug=1
+
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/Modules.conf .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/Modules.conf
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/Modules.conf	2000-12-31 06:23:13.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/Modules.conf	2004-01-19 17:36:28.000000000 +1100
@@ -1,3 +1,6 @@
+# For modern kernels (2.6 or above), this belongs in /etc/modprobe.conf
+# For for 2.4 kernels or earlier, this belongs in /etc/modules.conf.
+
 # i2c
 alias char-major-89	i2c-dev
 options i2c-core	i2c_debug=1
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/README .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/README
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/bttv/README	2003-09-21 17:31:19.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/bttv/README	2004-01-19 17:37:08.000000000 +1100
@@ -50,10 +50,10 @@ in the kernel to get the videodev.o modu
 Make bttv work with your card
 -----------------------------
 
-Setup your /etc/modules.conf file and let kmod load the modules.
+Setup your /etc/modprobe.conf file and let kmod load the modules.
 See also:
 
-Modules.conf:	some sample entries for /etc/modules.conf
+Modules.conf:	some sample entries for /etc/modprobe.conf
 Insmod-options:	list of all insmod options available for bttv and
 		the helper modules.
 MAKEDEV:	a script to create the special files for v4l
@@ -68,7 +68,7 @@ to load them automagically by calling re
 obviously works only with kmod enabled.
 
 If bttv takes very long to load (happens sometimes with the cheap
-cards which have no tuner), try adding this to your modules.conf:
+cards which have no tuner), try adding this to your modprobe.conf:
 	options i2c-algo-bit bit_test=1
 
 The most important insmod option for bttv is "card=n" to select the
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/Documentation/video4linux/meye.txt .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/meye.txt
--- .24478-linux-2.6.1-bk4/Documentation/video4linux/meye.txt	2003-11-24 15:42:24.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/Documentation/video4linux/meye.txt	2004-01-19 17:37:17.000000000 +1100
@@ -42,7 +42,7 @@ Driver options:
 ---------------
 
 Several options can be passed to the meye driver, either by adding them
-to /etc/modules.conf file, when the driver is compiled as a module, or
+to /etc/modprobe.conf file, when the driver is compiled as a module, or
 by adding the following to the kernel command line (in your bootloader):
 
 	meye=gbuffers[,gbufsize[,video_nr]]
@@ -59,7 +59,7 @@ Module use:
 -----------
 
 In order to automatically load the meye module on use, you can put those lines
-in your /etc/modules.conf file:
+in your /etc/modprobe.conf file:
 
 	alias char-major-81 videodev
 	alias char-major-81-0 meye
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/arch/i386/Kconfig .24478-linux-2.6.1-bk4.updated/arch/i386/Kconfig
--- .24478-linux-2.6.1-bk4/arch/i386/Kconfig	2004-01-10 13:59:02.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/arch/i386/Kconfig	2004-01-19 16:16:21.000000000 +1100
@@ -602,8 +602,6 @@ config MICROCODE
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called microcode.
-	  If you use modprobe or kmod you may also want to add the line
-	  'alias char-major-10-184 microcode' to your /etc/modules.conf file.
 
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/arch/m68k/Kconfig .24478-linux-2.6.1-bk4.updated/arch/m68k/Kconfig
--- .24478-linux-2.6.1-bk4/arch/m68k/Kconfig	2004-01-10 13:59:05.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/arch/m68k/Kconfig	2004-01-19 16:17:15.000000000 +1100
@@ -1073,8 +1073,7 @@ config GEN_RTC
 	  precision in some cases.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called genrtc. To load the module automatically
-	  add 'alias char-major-10-135 genrtc' to your /etc/modules.conf
+	  module will be called genrtc.
 
 config GEN_RTC_X
 	bool "Extended RTC operation"
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/char/Kconfig .24478-linux-2.6.1-bk4.updated/drivers/char/Kconfig
--- .24478-linux-2.6.1-bk4/drivers/char/Kconfig	2003-10-26 14:52:48.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/char/Kconfig	2004-01-19 16:10:02.000000000 +1100
@@ -796,8 +796,7 @@ config GEN_RTC
 	  precision in some cases.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called genrtc. To load the module automatically
-	  add 'alias char-major-10-135 genrtc' to your /etc/modules.conf
+	  module will be called genrtc.
 
 config GEN_RTC_X
 	bool "Extended RTC operation"
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/char/ip2/ip2.h .24478-linux-2.6.1-bk4.updated/drivers/char/ip2/ip2.h
--- .24478-linux-2.6.1-bk4/drivers/char/ip2/ip2.h	2003-09-22 10:06:01.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/drivers/char/ip2/ip2.h	2004-01-19 16:10:56.000000000 +1100
@@ -59,7 +59,7 @@
  * console warning.
  
  * When the driver is loaded as a module these setting can be overridden on the 
- * modprobe command line or on an option line in /etc/modules.conf.
+ * modprobe command line or on an option line in /etc/modprobe.conf.
  * If the driver is built-in the configuration must be 
  * set here for ISA cards and address set to 1 and 2 for PCI and EISA.
  *
@@ -80,7 +80,7 @@
 
  /* this structure is zeroed out because the suggested method is to configure
   * the driver as a module, set up the parameters with an options line in
-  * /etc/modules.conf and load with modprobe, kerneld or kmod, the kernel
+  * /etc/modprobe.conf and load with modprobe or kmod, the kernel
   * module loader
   */
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/char/isicom.c .24478-linux-2.6.1-bk4.updated/drivers/char/isicom.c
--- .24478-linux-2.6.1-bk4/drivers/char/isicom.c	2003-10-09 18:02:52.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/drivers/char/isicom.c	2004-01-19 16:10:18.000000000 +1100
@@ -29,7 +29,7 @@
  *	You can find the original tools for this direct from Multitech
  *		ftp://ftp.multitech.com/ISI-Cards/
  *
- *	Having installed the cards the module options (/etc/modules.conf)
+ *	Having installed the cards the module options (/etc/modprobe.conf)
  *
  *	options isicom   io=card1,card2,card3,card4 irq=card1,card2,card3,card4
  *
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/media/dvb/Kconfig .24478-linux-2.6.1-bk4.updated/drivers/media/dvb/Kconfig
--- .24478-linux-2.6.1-bk4/drivers/media/dvb/Kconfig	2004-01-10 13:59:12.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/media/dvb/Kconfig	2004-01-19 16:15:09.000000000 +1100
@@ -18,11 +18,12 @@ config DVB
 	  Please report problems regarding this driver to the LinuxDVB 
 	  mailing list.
 
-	  You might want add the following lines to your /etc/modules.conf:
+	  You might want add the following lines to your /etc/modprobe.conf:
 	  	
 	  	alias char-major-250 dvb
 	  	alias dvb dvb-ttpci
-	  	below dvb-ttpci alps_bsru6 alps_bsrv2 \
+	  	install dvb-ttpci /sbin/modprobe --first-time -i dvb-ttpci && \
+			/sbin/modprobe -a alps_bsru6 alps_bsrv2 \
 	  			grundig_29504-401 grundig_29504-491 \
 	  			ves1820
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/net/wan/Kconfig .24478-linux-2.6.1-bk4.updated/drivers/net/wan/Kconfig
--- .24478-linux-2.6.1-bk4/drivers/net/wan/Kconfig	2004-01-17 15:35:23.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/net/wan/Kconfig	2004-01-19 16:08:28.000000000 +1100
@@ -434,8 +434,9 @@ config FARSYNC
 	  To compile this driver as a module, choose M here: the module will be
 	  called farsync.  If you want the module to be automatically loaded
 	  when the interface is referenced then you should add
-	  "alias hdlcX farsync" to /etc/modules.conf for each interface, where
-	  X is 0, 1, 2, ...
+	  "alias hdlcX farsync" to /etc/modprobe.conf for each interface, where
+	  X is 0, 1, 2, etc, or simply use "alias hdlc* farsync" to indicate
+	  all of them.
 
 config DLCI
 	tristate "Frame relay DLCI support"
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/scsi/aic7xxx/aic79xx_osm.c .24478-linux-2.6.1-bk4.updated/drivers/scsi/aic7xxx/aic79xx_osm.c
--- .24478-linux-2.6.1-bk4/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-01-17 15:35:24.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-01-19 16:11:39.000000000 +1100
@@ -452,14 +452,14 @@ MODULE_PARM_DESC(aic79xx,
 "	seltime:<int>		Selection Timeout:\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
 "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample /etc/modprobe.conf line:\n"
 "		Enable verbose logging\n"
 "		Set tag depth on Controller 2/Target 2 to 10 tags\n"
 "		Shorten the selection timeout to 128ms\n"
 "\n"
 "	options aic79xx 'aic79xx=verbose.tag_info:{{}.{}.{..10}}.seltime:1'\n"
 "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample /etc/modprobe.conf line:\n"
 "		Change Read Streaming for Controller's 2 and 3\n"
 "\n"
 "	options aic79xx 'aic79xx=rd_strm:{..0xFFF0.0xC0F0}'");
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/scsi/aic7xxx/aic7xxx_osm.c .24478-linux-2.6.1-bk4.updated/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- .24478-linux-2.6.1-bk4/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-01-17 15:35:24.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-01-19 16:11:25.000000000 +1100
@@ -472,7 +472,7 @@ MODULE_PARM_DESC(aic7xxx,
 "	seltime:<int>		Selection Timeout\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
 "\n"
-"	Sample /etc/modules.conf line:\n"
+"	Sample /etc/modprobe.conf line:\n"
 "		Toggle EISA/VLB probing\n"
 "		Set tag depth on Controller 1/Target 1 to 10 tags\n"
 "		Shorten the selection timeout to 128ms\n"
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/scsi/qla2xxx/qla_os.c .24478-linux-2.6.1-bk4.updated/drivers/scsi/qla2xxx/qla_os.c
--- .24478-linux-2.6.1-bk4/drivers/scsi/qla2xxx/qla_os.c	2004-01-17 15:35:25.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/scsi/qla2xxx/qla_os.c	2004-01-19 16:12:11.000000000 +1100
@@ -70,7 +70,7 @@ MODULE_PARM_DESC(ql2xretrycount,
 int displayConfig;
 module_param(displayConfig, int, 0);
 MODULE_PARM_DESC(displayConfig,
-		"If 1 then display the configuration used in /etc/modules.conf.");
+		"If 1 then display the configuration used in /etc/modprobe.conf.");
 
 int ql2xplogiabsentdevice;
 module_param(ql2xplogiabsentdevice, int, 0);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/drivers/scsi/scsi.c .24478-linux-2.6.1-bk4.updated/drivers/scsi/scsi.c
--- .24478-linux-2.6.1-bk4/drivers/scsi/scsi.c	2004-01-17 15:35:25.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/drivers/scsi/scsi.c	2004-01-19 16:11:05.000000000 +1100
@@ -22,7 +22,7 @@
  *  support added by Michael Neuffer <mike@i-connect.net>
  *
  *  Added request_module("scsi_hostadapter") for kerneld:
- *  (Put an "alias scsi_hostadapter your_hostadapter" in /etc/modules.conf)
+ *  (Put an "alias scsi_hostadapter your_hostadapter" in /etc/modprobe.conf)
  *  Bjorn Ekwall  <bj0rn@blox.se>
  *  (changed to kmod)
  *
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/net/Kconfig .24478-linux-2.6.1-bk4.updated/net/Kconfig
--- .24478-linux-2.6.1-bk4/net/Kconfig	2003-11-24 15:42:33.000000000 +1100
+++ .24478-linux-2.6.1-bk4.updated/net/Kconfig	2004-01-19 16:07:00.000000000 +1100
@@ -32,8 +32,7 @@ config PACKET
 	  to work, choose Y.
 
 	  To compile this driver as a module, choose M here: the module will
-	  be called af_packet. If you use modprobe or kmod, you may also
-	  want to add "alias net-pf-17 af_packet" to /etc/modules.conf.
+	  be called af_packet.
 
 	  If unsure, say Y.
 
@@ -67,11 +66,8 @@ config UNIX
 	  want to say Y here.
 
 	  To compile this driver as a module, choose M here: the module will be
-	  called unix.  If you try building this as a module and you have
-	  said Y to "Kernel module loader support" above, be sure to add
-	  'alias net-pf-1 unix' to your /etc/modules.conf file. Note that
-	  several important services won't work correctly if you say M here
-	  and then neglect to load the module.
+	  called unix.  Note that several important services won't work
+	  correctly if you say M here and then neglect to load the module.
 
 	  Say Y unless you know what you are doing.
 
@@ -127,9 +123,7 @@ config IPV6
 	  in the kernel source.
 
 	  To compile this protocol support as a module, choose M here: the 
-	  module will be called ipv6.  If you try building this as a module 
-	  and you have said Y to "Kernel module loader support" above, 
-	  be sure to add 'alias net-pf-10 ipv6' to your /etc/modules.conf file.
+	  module will be called ipv6.
 
 	  It is safe to say N here for now.
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .24478-linux-2.6.1-bk4/sound/core/seq/seq_dummy.c .24478-linux-2.6.1-bk4.updated/sound/core/seq/seq_dummy.c
--- .24478-linux-2.6.1-bk4/sound/core/seq/seq_dummy.c	2003-09-21 17:24:50.000000000 +1000
+++ .24478-linux-2.6.1-bk4.updated/sound/core/seq/seq_dummy.c	2004-01-19 17:40:01.000000000 +1100
@@ -46,7 +46,7 @@
 
   The number of ports to be created can be specified via the module
   paramter "ports".  For example, to create four ports, add the
-  following option in /etc/modules.conf:
+  following option in /etc/modprobe.conf:
 
 	option snd-seq-dummy ports=4
 

--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
