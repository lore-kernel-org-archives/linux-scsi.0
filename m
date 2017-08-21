From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc
Date: Mon, 21 Aug 2017 16:27:12 -0400
Message-ID: <yq1h8x0ekf3.fsf@oracle.com>
References: <1502902815.3305.22.camel@abdul.in.ibm.com>
        <1502904072.2421.3.camel@wdc.com>
        <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com>
        <1502985161.2615.8.camel@wdc.com>
        <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
        <1503092473.2622.17.camel@wdc.com>
        <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com> (Brian
        King's message of "Fri, 18 Aug 2017 16:57:59 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org


Brian,

>> Thanks for the detailed analysis. This is very helpful. Have you
>> considered to change the ipr driver such that it terminates REPORT
>> SUPPORTED OPERATION CODES commands with the appropriate check
>> condition code instead of DID_ERROR?
>
> Yes. That data is actually in the sense buffer, but since I'm also
> setting DID_ERROR, scsi_decide_disposition isn't using it. I've got a
> patch to do just as you suggest, to stop setting DID_ERROR when there
> is more detailed error data available, but it will need some
> additional testing before I submit, as it will impact much more than
> just this case.

I agree. In this case where a command is not supported, a check
condition would be a better way to signal the failure to the SCSI
midlayer.

-- 
Martin K. Petersen	Oracle Linux Engineering
