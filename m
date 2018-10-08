From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: -Wswitch Clang warnings in drivers/scsi
Date: Mon, 08 Oct 2018 11:47:09 -0700
Message-ID: <1539024429.64374.40.camel@acm.org>
References: <20181004183047.GA1885@flashbox>
         <1538678069.230807.6.camel@acm.org> <20181004184540.GA17513@flashbox>
         <CAKwvOd=FrGZ-oh5Q9RGQD2GNORZrqwAZUzNYN+hTKkp5wrfrqw@mail.gmail.com>
         <20181005065754.GA18637@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005065754.GA18637@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-10-04 at 23:57 -0700, Nathan Chancellor wrote:
+AD4 Regardless of how the overflow is handled within the switch statement,
+AD4 the overflow is also happening when passing in these values to the ioctl,
+AD4 right? I mean these case values are defined in the uapi files so that
+AD4 userspace can easily pass them in to the ioctl, meaning those values are
+AD4 being passed in as a signed integer and I would assume subsequently
+AD4 overflowing unless I'm just missing something here.

>From the user space header +ADw-sys/ioctl.h+AD4:

extern int ioctl (int +AF8AXw-fd, unsigned long int +AF8AXw-request, ...) +AF8AXw-THROW+ADs

>From the kernel header +ADw-linux/fs.h+AD4:

	long (+ACo-unlocked+AF8-ioctl) (struct file +ACo, unsigned int, unsigned long)+ADs
	long (+ACo-compat+AF8-ioctl) (struct file +ACo, unsigned int, unsigned long)+ADs

Why has the second argument been declared as +ACI-unsigned long+ACI in the glibc
headers and as +ACI-unsigned int+ACI in the kernel headers? That's not clear to me.

Bart.
