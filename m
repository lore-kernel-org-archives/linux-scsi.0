From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: PROBLEM: SYM53C8XX errors while reading tape
Date: Sat, 23 Nov 2002 17:45:11 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211231345470.26253-100000@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.44.0211231231290.26253-100000@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0211231231290.26253-100000@filesrv1.baby-dragons.com>
List-Id: linux-scsi@vger.kernel.org
To: Russell Senior <seniorr@aracnet.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>


	Hello Russell ,  I stand(well sit) corrected .  The data you sent
	matched exactly ,minus differant controllers, my setup after I
	swapped over to a python not the same vesrion as yours tho.
	But ,  Mine appears to function quite well .  Had to re-install
	the old bugger to do this .  No problems running the commands you
	sent along except I did not try backing up the whole '/' I just
	did /root whihc is ~ 288MB .  Below are the cmnds in the order I
	ran them .  I forgot to record the dmesg putput .  Basically there
	was not any ,  beyond the last two lines you reported .
	The 'kernel:' is from an older dmesg for model & vendor info .
	I was of the opinion that the SYM53C8XX_2 was supposed to report
	itself as   sym_2:  in the demsg output .  I see now that it DOES
	NOT do so .  Which I beleive is not what Gerard had said it was to
	do way back when .  Hth ,  JimL

mtx -f /dev/sg3 load 1
mt -f /dev/nst0 setblk 32768
mtx -f /dev/sg3 status
mt -f /dev/nst0 status
tar -C /root -b 64 -clvf /dev/nst0 .
mt -f /dev/nst0 status
mt -f /dev/nst0 rewind
tar -b 64 -tvf /dev/nst0
mt -f /dev/nst0 rewind
mtx -f /dev/sg3 unload
dmesg

kernel: Detected scsi disk sdb at scsi0, channel 0, id 1, lun 0
kernel:   Vendor: ARCHIVE   Model: 4586XX 28887-XXX  Rev: 0420
kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
kernel: Detected scsi tape st0 at scsi0, channel 0, id 4, lun 0
kernel:   Vendor: ARCHIVE   Model: 4586XX 28887-XXX  Rev: 0420
kernel:   Type:   Medium Changer                     ANSI SCSI revision: 02
kernel: Detected scsi generic sgd at scsi0, channel 0, id 4, lun 1



On Sat, 23 Nov 2002, Mr. James W. Laferriere wrote:

>
> 	Hello Russell ,  Sorry about taking the original reply off list
> 	I should know better .  According to the dmesg & the log dumps
> 	you sent you were (were they edited?) .  Please make sure that
> 	SYM53C8XX_2 driver was the only driver in the 53c8* series that
> 	was selected or That modules were not being selected anyway .
>
> 	I for one KNOW that if the SYM53C8XX driver is compiled in OR
> 	listed first in the module.conf file IT will be loaded in front of
> 	the SYM53C8XX_2 and this will keep the sym2 from loading at all .
> 	And I have seen (at least three times) a condition where the
> 	SYM53C8XX_2 WAS compiled IN (just like you) and the SYM53C8XX was
> 	a module and it was -still- loaded & began conflicting with the
> 	SYM53C8XX_2 during use .  Hth ,  JimL
>
> ps:	On my systems I have had at onetime or another almost every
> 	(older) scsi tape drive manufactured .  And damn near everytime I
> 	have had a problem it has been some mistake on my end .  A bus a
> 	tad to long ,  the terminator I bought was just a little to good
> 	to beleive price wise ...
>
> On 22 Nov 2002, Russell Senior wrote:
>
> > >>>>> "James" == James W Laferriere <babydr@baby-dragons.com> writes:
> >
> > James> 	Hello Russell , Could you try the SYM53C8XX_2 driver ?  I
> > James> beleive that this may help .  JimL
> >
> > I _was_ using the SYM53C8XX_2 driver.  Here's the relevant portion of
> > my .config for 2.4.18:
> >
> >   # CONFIG_SCSI_NCR53C7xx is not set
> >   CONFIG_SCSI_SYM53C8XX_2=y
> >   CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> >   CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> >   CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> >   # CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set
>
> --
>        +------------------------------------------------------------------+
>        | James   W.   Laferriere | System    Techniques | Give me VMS     |
>        | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
>        | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
>        +------------------------------------------------------------------+
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+


