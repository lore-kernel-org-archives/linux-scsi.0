From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: linux-next: Tree for November 23
Date: Tue, 23 Nov 2010 20:04:12 +0100
Message-ID: <AANLkTikLJW0be+kVgEnAZDbiDMVbYOrA7f5VYs+KHSe_@mail.gmail.com>
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
	<AANLkTi===xonvuovLS5Ch=coMDjzLQ4XSsPRDowDJ4L2@mail.gmail.com>
	<20101123091551.f3ed937f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101123091551.f3ed937f.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2010/11/23 Randy Dunlap <randy.dunlap@oracle.com>:
> On Tue, 23 Nov 2010 16:43:22 +0100 Zimny Lech wrote:
>
>> Ave
>>
>> 2010/11/23 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101122:
>> >
>>
>>
>> Random config generator has failed :)
>
> Hi,
> What do you mean by this?

This is what I get from "make" after "make randconfig".

> =A0I'm not seeing any randconfig generator problems.
> Are you using any options or inputs to kconfig?

No.

I'm using script below to build kernel - nothing really unusual. Log
and config for this failed build are attached to previous email

import os, sys, time
from hexer_io import *

class BuildKernel:
        def __init__(self, options, config):
                self.options =3D options
                self.config =3D config
                self.timestamp =3D ""

        def generate_timestamp(self):
                self.timestamp =3D time.strftime("%y-%m-%d-%H-%M-%S",
time.gmtime())
                print("timestamp =3D " + self.timestamp)

        def check_dirs(self):
                if not os.path.isdir(self.config["KERNEL_DIR"]):
                        print("KERNEL_DIR=3D" +
self.config["KERNEL_DIR"] + " doesn't exist")
                        sys.exit(1)
                if not os.path.isdir(self.config["KERNEL_OBJ_DIR"]):
                        print("KERNEL_OBJ_DIR=3D" +
self.config["KERNEL_OBJ_DIR"] + " doesn't exist")
                        sys.exit(1)
                if not os.path.isdir(self.config["HEXER_DIR"] + "/build=
s/"):
                        os.system("mkdir " + self.config["HEXER_DIR"]
+ "/builds/")

        def kernel_make_mrproper(self):
                print("make mrproper")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=3D\"C\" make mrproper &> /dev/null")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=3D\"C\" make O=3D" + self.config["KERNEL_OBJ_DIR"] + " mrproper &>
/dev/null")

        def kernel_make_clean(self):
                print("make clean")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=3D\"C\" make O=3D" + self.config["KERNEL_OBJ_DIR"] + " clean &>
/dev/null")

        def kernel_make_randconfig(self):
                print("make randconfig")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=3D\"C\" make O=3D" + self.config["KERNEL_OBJ_DIR"] + " randconfig =
&>
/dev/null")
                os.system("cp " + self.config["KERNEL_OBJ_DIR"] +
"/.config " + self.config["HEXER_DIR"] + "/builds/" + self.timestamp +
"-config")

        def kernel_make(self):
                print("make")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=3D\"C\" make O=3D" + self.config["KERNEL_OBJ_DIR"] + " &> " +
self.config["HEXER_DIR"] + "/builds/" + self.timestamp + "-buildlog")

        def build_random_kernel(self, loop):
                while True:
                        IOStopFile.get_stop_file(self.config)
                        self.generate_timestamp()
                        #self.kernel_make_clean()
                        self.kernel_make_randconfig()
                        self.kernel_make()
                        if not loop:
                                break

        def build(self):
                self.kernel_make_mrproper()
                if self.options.mode =3D=3D "brk":
                        self.build_random_kernel(self.options.loop)

        def run(self):
                self.check_dirs()
                self.build()


>
>
>> USB Gadget Support (USB_GADGET) [Y/n/?] y
>> =A0 Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
>> =A0 Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILE=
S) [N/y/?] n
>> =A0 Debugging information files in debugfs (DEVELOPMENT)
>> (USB_GADGET_DEBUG_FS) [Y/n/?] y
>> =A0 Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
>> =A0 USB Peripheral Controller
>> =A0 > 1. Renesas R8A66597 USB Peripheral Controller (USB_GADGET_R8A6=
6597)
>> =A0 =A0 2. Renesas M66592 USB Peripheral Controller (USB_GADGET_M665=
92)
>> =A0 choice[1-2?]: 1
>> =A0 USB Gadget Drivers
>> =A0 =A0 1. Gadget Zero (DEVELOPMENT) (USB_ZERO)
>> =A0 =A0 2. Audio Gadget (EXPERIMENTAL) (USB_AUDIO)
>> =A0 > 3. Ethernet Gadget (with CDC Ethernet support) (USB_ETH)
>> =A0 =A0 4. Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_=
SERIAL)
>> =A0 =A0 5. Printer Gadget (USB_G_PRINTER)
>> =A0 =A0 6. CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSIT=
E)
>> =A0 =A0 7. HID Gadget (USB_G_HID)
>> =A0 =A0 8. EHCI Debug Device Gadget (USB_G_DBGP)
>> =A0 choice[1-8?]: 3
>> =A0 =A0 RNDIS support (USB_ETH_RNDIS) [Y/n/?] (NEW) aborted!
>>
>> Console input/output is redirected. Run 'make oldconfig' to update
>> configuration.
>>
>> make[3]: *** [silentoldconfig] Error 1
>> make[2]: *** [silentoldconfig] Error 2
>> make[1]: *** No rule to make target `include/config/auto.conf', need=
ed
>> by `include/config/kernel.release'. =A0Stop.
>> make: *** [sub-make] Error 2
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your c=
ode ***
>



--=20
Slawa!
N.P.S.

Chwa=B3a tobie, Szatanie, cze=B6=E6 na wysoko=B6ciach
Nieba, gdzie kr=F3lowa=B3e=B6, chwa=B3a w g=B3=EAboko=B6ciach
Piek=B3a, gdzie zwyci=EA=BFony, trwasz w dumnym milczeniu!
Uczy=F1, niechaj ma dusza spocznie z Tob=B1 w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko=B6cio=B3a, kt=F3ry nie przeminie!
