From: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Subject: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Mon, 16 Dec 2002 16:19:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <170040000.1040080786@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dledford@redhat.com

In debugging a different bug in the new 2.5.X port of the aic7xxx driver,
I came across this behavior in scsi_probe_and_add_lun()

        /*
         * Since we reuse the same sdevscan over and over with different
         * target and lun values, we have to destroy and then recreate
         * any possible low level attachments since they very will might
         * also store the id and lun numbers in some form and need updating
         * with each scan.
         */
        if (sdevscan->host->hostt->slave_destroy)
                sdevscan->host->hostt->slave_destroy(sdevscan);
        if (sdevscan->host->hostt->slave_alloc)
                sdevscan->host->hostt->slave_alloc(sdevscan);

So, you cannot rely on slave_destroy as an indication of a device really
going away in the physical sense.  In SPI, for example, the driver can only
tell that the device is gone if a command is issued to it.  I had hoped that
I could detect hot-pull/scsi-remove-single-device operations via this
callback.
Granted, for some drivers, recreating and destroying state associated with a
particular device might be pretty cheap, but certainly not in all cases.
The
aic7xxx and aic79xx drivers maintain domain validation and other negotiation
state in these structures.  You certainly don't want to go through another
full
Domain Validation sequence the next time a device is allocated via
slave_alloc() if the device isn't really "new".

Any chance in changing this behavior?

Thanks,
Justin
