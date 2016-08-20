From: "T. Smith" <tlsmith3777@gmail.com>
Subject: Moving GPIO interrupts and IPIs to a core other than 0
Date: Sat, 20 Aug 2016 12:19:15 -0500
Message-ID: <A331A298-5409-481F-8CCF-CA1B2139A144@gmail.com>
References: <F4438E9E-D120-4B55-AACD-1D7560A3EA87@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F4438E9E-D120-4B55-AACD-1D7560A3EA87@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On the 4.1.8-rt8+gdb51baf SMP PREMPT RT kernel, GPIO interrupts are assigned=
 to core 0 as are the following IPI interrupts:

Arch_timer
Rescheduling Interrupt
Function call interrupt

Trying to assign GPIO interrupts to core 2 for example, or trying to reassig=
n or move IPI interrupts running on core 0 to some other core does not seem p=
ossible since attempting to move these was unsuccessful. Successfully moved o=
ther ISRs and tasks to other cores with no problem.

1.  How does one control GPIO ISR affinity when GPIOs interrupts always appe=
ar to run on Core 0? How do we assign GPIO interrupts to any core other than=
 Core#0.=20

2.  It looks like the existing GPIO driver does not support assigning interr=
upts to any other core than CPU0, is this correct?

3.  If so, why are GPIO interrupts assigned only to Core#0?

4.  There are virtual GPIO interrupts and GPIO hardware interrupts, can eith=
er or both interrupts be assigned to a specific core other than Core#0?

5.  Is it possible to isolate a given CPU core from the following IPI interr=
upts, and if so, how do we isolate CPU0 from the following IPI interrupts.  I=
f not, why are these always serviced on boot core 0? Arch_timer, Reschedulin=
g Interrupt, Function call interrupt

Creating the GPIO interrupt:

root:~# echo 498 > /sys/class/gpio/export
root:~# echo falling > /sys/class/gpio/gpio498/edge
root:~# cat /proc/interrupts

               CPU0         CPU1       CPU2       CPU3
[....]        =20
66:            0            0          0          0     GIC 106
Level        1740000.jr
67:            0            0          0          0     mpc8xxx-gpio   18
Edge         gpiolib
IPI0:          3226         4833       4237      4170   Recheduling interrup=
ts
IPI1:            17           21         19        23   Function call interr=
upts

Setting GPIO affinity doesn=E2=80=99t work:

root:~# echo 1 > /proc/irq/67/smp_affinity_list-sh: echo: write error: Input=
/output error

Setting eMMC interrupt affinity works just fine:

root:~# echo 1 > /proc/irq/12/smp_affinity_list
root:~# cat /proc/interrupts

CPU0         CPU1       CPU2       CPU3
[....]        =20
1:            0            0          0          0     GIC 29
Edge        arch_timer
2:           35475          39336    28975       38803 GIC 30
Edge        arch_timer
11             9           0          0           0    GIC 75 Level    fsl-i=
fc
12:           3370         14         0           0    GIC 94 Level    mmc0
[...]

thx, Tracy
