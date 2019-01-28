From: <Don.Brace@microchip.com>
Subject: RE: [PATCH v4] scsi/ata: Use unsigned int for cmd's type in ioctls in
 scsi_host_template
Date: Mon, 28 Jan 2019 16:16:34 +0000
Message-ID: <SN6PR11MB2767DF2A2BEF95EE07C15172E1960@SN6PR11MB2767.namprd11.prod.outlook.com>
References: <20190114044206.6351-1-natechancellor@gmail.com>
 <20190126075256.29608-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190126075256.29608-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: natechancellor@gmail.com, axboe@kernel.dk, aacraid@microsemi.com, jejb@linux.ibm.com, martin.petersen@oracle.com, manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com, linuxdrivers@attotech.com, don.brace@microsemi.com, brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, ndesaulniers@google.com, bvanassche@acm.org
List-Id: linux-scsi@vger.kernel.org


Clang warns several times in the scsi subsystem (trimmed for brevity):

drivers/scsi/hpsa.c:6209:7: warning: overflow converting case value to swit=
ch condition type (2147762695 to 18446744071562347015) [-Wswitch]
        case CCISS_GETBUSTYPES:
             ^
drivers/scsi/hpsa.c:6208:7: warning: overflow converting case value to swit=
ch condition type (2147762694 to 18446744071562347014) [-Wswitch]
        case CCISS_GETHEARTBEAT:
             ^

The root cause is that the _IOC macro can generate really large numbers, wh=
ich don't find into type 'int', which is used for the cmd paremeter in the =
ioctls in scsi_host_template. My research into how GCC and Clang are handli=
ng this at a low level didn't prove fruitful. However, looking at the rest =
of the kernel tree, all ioctls use an 'unsigned int' for the cmd parameter,=
 which will fit all of the _IOC values in the scsi/ata subsystems.

Make that change because none of the ioctls expect to take a negative value=
, it brings the ioctls inline with the reset of the kernel, and it removes =
ambiguity, which is never good when dealing with compilers.

Link: https://github.com/ClangBuiltLinux/linux/issues/85
Link: https://github.com/ClangBuiltLinux/linux/issues/154
Link: https://github.com/ClangBuiltLinux/linux/issues/157
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

 static void __exit esas2r_exit(void)
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index ff67ef5d5347..=
28cfd3d01c5a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -251,10 +251,11 @@ static int number_of_controllers;

Acked-by: Don Brace <don.brace@microsemi.com>

=20
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index f564af8949e8..5d9ccbab7581 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6043,7 +6043,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *c=
trl_info, void __user *arg)
 	return rc;
 }

Acked-by: Don Brace <don.brace@microsemi.com>
=20
