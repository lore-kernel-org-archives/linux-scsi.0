From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Interpreting SCSI CDB response over FC(FCP-2)
Date: Thu, 14 Nov 2002 22:52:05 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD38E65.6000008@torque.net>
References: <F123b7PFk6HqzVnWRZg0000c047@hotmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: shankar krishna <kshan01@hotmail.com>
Cc: linux-scsi@vger.kernel.org

shankar krishna wrote:
> Hi,
> I am looking for specific information in the SCSI response
> for the CDB sent by following method.
> 
> if (ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))
> {
> /* ERROR */
> }
> 
> The above command sends the CDB and the response comes
> as below in cdb_buf. From DGilbert's doc,(www.torque.net/sg)
> 
>   struct sdata {
>    unsigned int inlen;     [i] Length of data written to device
>    unsigned int outlen;    [i] Length of data read from device
>    unsigned char cmd[x];   [i] SCSI command (6 <= x <= 16)
>                            [o] Data read from device starts here
>                            [o] On error, sense buffer starts here
>    unsigned char wdata[y]; [i] Data written to device starts here
>   };
> 
> Question:
> 1. I want to see the SCSI status byte from 12th byte of FCP_RESP
> payload! how can get that?

if ((res = ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))) {
     scsi_status = res & 0xff;
     .....
}

> 2. Information FCP_SNS_LEN and FCP_RSP_LEN are also needed but not
> able to get from the above structure as it straight away returns
> the sense key structure! How to get those information?
> 3. If possible, can anybody throw light on how to get the Whole
> FCP response payload as such??
> 
> Any other function call otherthan ioctl can fetch me this info??

I'm not sure what happens in the FC world. However the scsi
subsystem mid level [which is what processes
SCSI_IOCTL_SEND_COMMAND] leaves those sort of details to the
lower level driver. The only way that I can see to get the
whole FCP response payload would be via an ioctl in the
lower level driver.

Doug Gilbert

