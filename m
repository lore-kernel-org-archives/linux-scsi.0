From: "shankar krishna" <kshan01@hotmail.com>
Subject: Re: building SCSI CDB over FC
Date: Fri, 08 Nov 2002 14:03:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F10FGcbNZOBPr0ebmeG00001ecf@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: aksumit@india.hp.com
Cc: linux-scsi@vger.kernel.org

Sumit:
You are correct. I sent the
following command to send the
CDB. It did send correctly.

if (ioctl(sd_fd,SCSI_IOCTL_SEND_COMMAND,&cdb_buf))
{
/* ERROR */
}

where cdb_buf is of type Scsi_Ioctl_Command.

DGilbert:
"
Notes:
The SCSI command length is determined by examining the 1st byte of the given 
command [1] . There is no way to override this.
"

The above claim that 1st octet should be the length
of CDB is not true...In the analyser I could see
that "if I sent the length of CDB it is sending
it as OPCODE" which essentially is the first byte.

You may want to correct it in the
document(www.torque.net/sg) that you
told me. It was very useful.

Thanks,
-Shankar.

>From: Sumit Agarwal <aksumit@india.hp.com>
>To: shankar krishna <kshan01@hotmail.com>
>CC: linux-scsi@vger.kernel.org
>Subject: Re: building SCSI CDB over FC
>Date: Fri, 08 Nov 2002 11:52:58 -0600
>
>Check the r_ctl bits of your FCP CDB while generating your
>FCP IU. It should be unsolicited command. The best way to
>send your commands are using ioctl's so try to use them.
>
>Thanks
>- Sumit
>
>shankar krishna wrote:
> >
> > Hi,
> >
> > I am trying to send SCSI CDB over Fibre channel HBA.
> >
> > Using IBM FC disk drive and qlogic HBA(QLA2300).
> >
> > I want to build my own CDB (not with 'write' cmd which
> > sends an "ex write" to target) - eventually to build some
> > vendor specific CDBs!
> >
> > Can anybody help me in this?
> >
> > Rgds,
> > -Shankar.
> > PS: I am using FC analyser(FCacccess) inbetween Drive and HBA to
> > see the frames and their contents. If I do a "write"
> > of my own CDB, it sends it as data not as a command!!
> >
> > _________________________________________________________________
> > MSN 8 helps eliminate e-mail viruses. Get 2 months FREE*.
> > http://join.msn.com/?page=features/virus
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
><< aksumit.vcf >>


_________________________________________________________________
The new MSN 8: smart spam protection and 2 months FREE*  
http://join.msn.com/?page=features/junkmail

