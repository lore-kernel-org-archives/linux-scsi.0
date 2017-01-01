From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sun, 01 Jan 2017 11:33:11 -0500 (EST)
Message-ID: <20170101.113311.417107391370623850.davem@davemloft.net>
References: <20161229080250.GA11605@infradead.org>
        <1483226343.2518.32.camel@linux.vnet.ibm.com>
        <1483280506.5512.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483280506.5512.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart.VanAssche@sandisk.com
Cc: jejb@linux.vnet.ibm.com, hch@infradead.org, jbaron@akamai.com, linux-kernel@vger.kernel.org, sagi@grimberg.me, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Date: Sun, 1 Jan 2017 14:22:11 +0000

> My recommendation is to revert commit 18f6084a989b ("scsi: mpt3sas: Fix
> secure erase premature termination"). Since the mpt3sas driver uses the
> single-queue approach and since the SCSI core unlocks the block layer
> request queue lock before the .queuecommand callback function is called,
> multiple threads can execute that callback function (scsih_qcmd() in this
> case) simultaneously. This means that using scsi_internal_device_block()
> from inside .queuecommand to serialize SCSI command execution is wrong.

But this causes a regression for the thing being fixed by that commit.

Why don't we figure out what that semantics that commit was trying to
achieve and implement that properly?
