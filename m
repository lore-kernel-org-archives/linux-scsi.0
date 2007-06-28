From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Some NCQ numbers...
Date: Thu, 28 Jun 2007 15:01:07 +0400
Message-ID: <468394F3.2010909@msgid.tls.msk.ru>
References: <468392CE.6010206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:24250 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbXF1LBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jun 2007 07:01:12 -0400
In-Reply-To: <468392CE.6010206@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Michael Tokarev wrote:
[]
> I'm planning to test several models of SCSI drives.  On SCSI front
> (or maybe with different drives - I don't know) things are WAY more
> interesting wrt TCQ.  Difference in results between 1 and 32 threads
> goes up to 4 times sometimes!.  But I'm a bit stuck with SCSI tests
> since I don't know how to turn off TCQ without rebooting a machine.

A quick followup, to demonstrate the "interesting" part.

Seagate SCSI ST3146854LC drive, 140Gb, 15KRPM, write cache disabled,
queue depth = 32:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  37.9   0.6   0.9   0.6   0.4/ 0.3
        4         0.9         0.7   0.6/ 0.4
       32         1.5         1.1   0.9/ 0.4
   8k   1  75.2   1.2   1.9   1.1   0.8/ 0.6
        4         1.7         1.5   1.1/ 0.7
       32         2.9         2.2   1.7/ 0.9
  16k   1  82.3   2.4   3.6   2.3   1.5/ 1.2
        4         3.3         2.9   2.2/ 1.4
       32         5.5         4.3   3.3/ 1.7
  32k   1  86.3   4.7   6.9   4.4   2.9/ 2.3
        4         6.4         5.6   4.2/ 2.7
       32        10.2         8.0   6.2/ 3.1
 128k   1  86.5  15.8  26.6  14.9   9.5/ 7.7
        4        20.6        18.2  13.5/ 8.5
       32        29.2        24.8  18.3/ 9.1
1024k   1  88.6  46.7  63.1  48.2  25.3/25.3
        4        51.7        51.3  33.5/21.8
       32        55.9        57.3  37.6/19.0


Fujitsu SCSI MAX3147NC drive, same parameters:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  37.4   0.7   1.0   0.6   0.4/ 0.3
        4         0.9         0.8   0.6/ 0.4
       32         1.5         1.2   0.9/ 0.4
   8k   1  32.9   1.3   1.9   1.2   0.7/ 0.7
        4         1.8         1.5   1.2/ 0.7
       32         2.8         2.3   1.7/ 0.9
  16k   1  89.6   2.6   3.7   2.4   1.4/ 1.3
        4         3.5         3.0   2.4/ 1.4
       32         5.4         4.4   3.3/ 1.7
  32k   1  87.9   4.8   7.0   4.4   2.6/ 2.6
        4         6.8         5.6   4.6/ 2.7
       32         9.9         8.3   6.2/ 3.1
 128k   1  90.7  16.2  22.5  15.3   8.6/ 8.6
        4        21.8        18.6  15.0/ 8.1
       32        28.6        25.0  18.2/ 9.1
1024k   1  90.6  48.9  60.0  47.4  25.3/25.9
        4        55.6        51.7  34.4/22.5
       32        59.8        56.2  38.6/19.7

/mjt

