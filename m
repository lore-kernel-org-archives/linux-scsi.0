From: "shankar krishna" <kshan01@hotmail.com>
Subject: Interpreting SCSI CDB response over FC(FCP-2)
Date: Thu, 14 Nov 2002 01:14:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F123b7PFk6HqzVnWRZg0000c047@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I am looking for specific information in the SCSI response
for the CDB sent by following method.

if (ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))
{
/* ERROR */
}

The above command sends the CDB and the response comes
as below in cdb_buf. From DGilbert's doc,(www.torque.net/sg)

   struct sdata {
    unsigned int inlen;     [i] Length of data written to device
    unsigned int outlen;    [i] Length of data read from device
    unsigned char cmd[x];   [i] SCSI command (6 <= x <= 16)
                            [o] Data read from device starts here
                            [o] On error, sense buffer starts here
    unsigned char wdata[y]; [i] Data written to device starts here
   };

Question:
1. I want to see the SCSI status byte from 12th byte of FCP_RESP
payload! how can get that?
2. Information FCP_SNS_LEN and FCP_RSP_LEN are also needed but not
able to get from the above structure as it straight away returns
the sense key structure! How to get those information?
3. If possible, can anybody throw light on how to get the Whole
FCP response payload as such??

Any other function call otherthan ioctl can fetch me this info??

Thanks,
-Shankar.





>From: Doug Ledford <dledford@redhat.com>
>To: shankar krishna <kshan01@hotmail.com>
>CC: aksumit@india.hp.com, linux-scsi@vger.kernel.org
>Subject: Re: building SCSI CDB over FC
>Date: Fri, 8 Nov 2002 18:12:44 -0500
>
>On Fri, Nov 08, 2002 at 02:03:16PM -0700, shankar krishna wrote:
> > Sumit:
> > You are correct. I sent the
> > following command to send the
> > CDB. It did send correctly.
> >
> > if (ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))
> > {
> > /* ERROR */
> > }
> >
> > where cdb_buf is of type Scsi_Ioctl_Command.
> >
> > DGilbert:
> > "
> > Notes:
> > The SCSI command length is determined by examining the 1st byte of the
> > given command [1] . There is no way to override this.
> > "
> >
> > The above claim that 1st octet should be the length
> > of CDB is not true...In the analyser I could see
> > that "if I sent the length of CDB it is sending
> > it as OPCODE" which essentially is the first byte.
> >
> > You may want to correct it in the
> > document(www.torque.net/sg) that you
> > told me. It was very useful.
>
>I believe you are mis-interpreting the documentation.  The first byte of
>the command is the opcode, and with scsi_ioctl_send_command the code reads
>the opcode and looks it up in a table to determine the length of the scsi
>command, and that length is the length that can't be over-ridden.
>
>--
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc.
>          1801 Varsity Dr.
>          Raleigh, NC 27606
>


_________________________________________________________________
Tired of spam? Get advanced junk mail protection with MSN 8. 
http://join.msn.com/?page=features/junkmail

