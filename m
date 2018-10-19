From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi/ata: Use unsigned int for cmd's type in ioctls in
 scsi_host_template
Date: Fri, 19 Oct 2018 12:38:45 -0700
Message-ID: <1539977925.81977.55.camel@acm.org>
References: <20181019175714.444-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019175714.444-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Bradley Grove <linuxdrivers@attotech.com>, Don Brace <don.brace@microsemi.com>, Brian King <brking@us.ibm.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-10-19 at 10:57 -0700, Nathan Chancellor wrote:
+AD4 Clang warns several times in the scsi subsystem (trimmed for brevity):
+AD4 
+AD4 drivers/scsi/hpsa.c:6209:7: warning: overflow converting case value to
+AD4 switch condition type (2147762695 to 18446744071562347015) +AFs--Wswitch+AF0
+AD4         case CCISS+AF8-GETBUSTYPES:
+AD4              +AF4
+AD4 drivers/scsi/hpsa.c:6208:7: warning: overflow converting case value to
+AD4 switch condition type (2147762694 to 18446744071562347014) +AFs--Wswitch+AF0
+AD4         case CCISS+AF8-GETHEARTBEAT:
+AD4              +AF4
+AD4 
+AD4 The root cause is that the +AF8-IOC macro can generate really large numbers,
+AD4 which don't find into type 'int', which is used for the cmd paremeter in
+AD4 the ioctls in scsi+AF8-host+AF8-template. My research into how GCC and Clang are
+AD4 handling this at a low level didn't prove fruitful. However, looking at
+AD4 the rest of the kernel tree, all ioctls use an 'unsigned int' for the
+AD4 cmd parameter, which will fit all of the +AF8-IOC values in the scsi/ata
+AD4 subsystems.
+AD4 
+AD4 Make that change because none of the ioctls expect to take a negative
+AD4 value, it brings the ioctls inline with the reset of the kernel, and it
+AD4 removes ambiguity, which is never good when dealing with compilers.

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
