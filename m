From: Dan Merillat <harik.attar@gmail.com>
Subject: Megaraid lockup on 2.6.[7-8]
Date: Fri, 6 Aug 2004 21:55:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c0c067900408061855df4dcae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_35_27542634.1091843732469"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.207]:40984 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S267900AbUHGBzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2004 21:55:32 -0400
Received: by mproxy.gmail.com with SMTP id 73so62853rnk
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2004 18:55:32 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

------=_Part_35_27542634.1091843732469
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This dump is from 2.6.7-rc3.  I'm using the in-kernel megaraid driver
on this Express 500.

0000:00:09.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 02)
        Subsystem: American Megatrends Inc. MegaRAID 475 Express
500/500LC RAID Controller

At this point, I'm really unsure what's going on.  It went from
"working" to "not working"
overnight, after a 2 month uptime with no problem.  Now it lasts
between 5 minutes and 3 hours before it locks up.  Somtimes the
lockups are 'soft', in that all disk IO hangs in wait.  Othertimes
it's hard (kernel panic and reload)

Due to the sudden nature of the problem, I suspected hardware. 
Starting with the SCSI cable,
RAID card, RAM, PCI riser card, motherboard... it's all been replaced.
 The megaraid itself
dosn't complain about problems accessing the drives (and the state is
always Optimal on reboot, no media or "other" errors on any drive)

Software wise, I've tried from 2.6.7-rc3, 2.6.7, 2.6.8-rc2 and 2.6.8-rc3.

I tried the 2.20 series, but they don't appear to recognize older
cards?  Are they for
U320 only or did I do something wrong?  (2.20 works fine on another
box with a U320 controller)

I'm at a loss.  I guess I could replace all the drives, being as
that's the last thing left to try,
but A) it's a serious PITA and B) they "appear" fine, even when doing
a full consistency check
via the Ctrl-M BIOS.   

This is made even more fun due to the fact it's a LIVE server, or was,
until two days ago.  It's
also stored in a colo facility about an hour from my house.   I'm
going to go back tomorrow
and try updating the firmware on the megaraid, but that's about the
only thing I can think
left to try.   Perhaps some PCI setting I should try?

Any help would be greatly appreciated!

(Different PCI Bus/Slot due to being in a different MB when I captured
this backtrace)


megaraid: found 0x101e:0x1960:bus 1:slot 2:func 0
scsi0:Found MegaRAID controller at 0xf8846000, IRQ:27
megaraid: [C170:3.13] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
scsi0 : LSI Logic MegaRAID C170 254 commands 16 targs 4 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID5  210G  Rev: C170
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 430116864 512-byte hdwr sectors (220220 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
...
megaraid: ABORTING-12793 cmd=2a <c=0 t=0 l=0>
megaraid: ABORTING-12796 cmd=2a <c=0 t=0 l=0>
megaraid: ABORTING-12797 cmd=2a <c=0 t=0 l=0>
megaraid: ABORTING-12798 cmd=2a <c=0 t=0 l=0>
megaraid: reservation reset failed.
megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
megaraid: reservation reset failed.
megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
megaraid: reservation reset failed.
megaraid: RESET-12793 cmd=2a <c=0 t=0 l=0>
scsi: Device offlined - not ready after error recovery: host 0 channel
0 id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel
0 id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel
0 id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 0 channel
0 id 0 lun 0
SCSI error : <0 0 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 197231
Buffer I/O error on device dm-64, logical block 24598
lost page write due to I/O error on dm-64
scsi0 (0:0): rejecting I/O to offline device

------=_Part_35_27542634.1091843732469
Content-Type: application/gzip; name="typhoon-config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="typhoon-config.gz"

H4sIAKbfE0ECA4xcW3PbOLJ+31/BqnnYpCqZ6GLL8lblAQJBCSOCgAFQl3lhKTaT6IwseSV5Jv73
p0HqApIAvQ9xzP4at0aj0Q00/Nu/fgvQ63H3vDquH1ebzVvwI9/m+9UxfwqeV3/lweNu+3394z/B
027772OQP62P//rtX5gnER1ni+Hg69v5g7H0+pHSsGthY5IQSXFGFcpChgCASn4L8O4ph1aOr/v1
8S3Y5H/nm2D3clzvtodrI2QhoCwjiUbxtUYcE5RkmDNBY3Kub1x0fRMc8uPry7UGNUfiWlIt1YwK
fCUIrugiYw8pScmVOlJhJiTHRKkMYaz9SDbrV2rH2uonSkOqa5+GB8UWU8yh1jTK1IRG+mt3cKZP
uBZxOr4y0mn5S5NS9AjIINST2NiIhCEJg/Uh2O6ORibnMlNoXC2ZutZypmRlty6VXOhkoSXKBFLK
UV+UarK4VkYEtwdHucITEmYJ56JJRapJCwkKY5qQJoKjB7t7GGdcaMronySLuMwU/GL3r1CKeLd6
Wn3bgKLtnl7hv8Pry8tub2kx42EaE6sfJSFLk5ijsEGGhnAT5CPFY6KJ4RJIMrubQJoRqShPKtK7
ShkYHGJVmouMITwpRVEMRux3j/nhsNsHx7eXPFhtn4LvuVlA+aGyLDNRUQZDITFKnM0bcMaXaEyk
F09Shh68qEoZo9oLj+hYMeFvm6q58qIn04Eknnh5iLrrdDpOmPWHAzdw4wNuWwCtsBdjbOHGBr4K
BRg1mjJKHbN/BWlFl05k1lrjjRudevoxvfPQh246lqnixI3NaQIaK/CgFe61ov3Q0+5S0gWtiuuK
zijC/az3niY5ZG1QzMQCTyzLaogLFIZVStzNMCxJcrLVt2dMzhVhmakBioAZHXNJ9YRVC89FNudy
qjI+rQI0mcWi1vaoum0Vi5oLFDYKjzmHFgXF9To1ibNUEYm5WFYxoGYCdowMRoKnsHyv8EQQnYFN
JbJGIyyNERg4qa2GYF1fPxKZYZGqr72r3EuzrZjbOAhJCBPaMyMxh13SNTDuIMLCrBIYJg0C7EFJ
hEo/oqIaBhM3ekIkQ7Gzq5rDhI+QE6PDqWsBUwxbMg/r3VCySgCR0fBs36P1/vmf1T4Pwv3673x/
KN2k074aupdFwid0PGGEOTpxQm7G9ohPxMHN2F+izi+0Z70jPTmpBuxvLjFoKSt+SeSydlQ+jBBs
UPakTdCMgC+AjSJYKi/J+LTBljvi7p98D07kdvUjf863x7MDGXxAWNBPARLs43VrFJWBKR7pOZKw
mFMFltMtXsGykKppw68w1UMjT3+vto/gLOPCT34FzxlaLzbmsmd0e8z331eP+cdA1T0PU4XlG8JX
NuJc10hmIUtYKtpekgWiYkKEi1Z4g1mk7MEWKHJvX2XTSEMTS8fslHCqNU9qrUWoTjl5xlw22m5b
XmXnYBr8aNsKLBhCMkrH/t6rWkcJrveczxsSFrg+QeC86+ryKCwzK21mU0sEs5SkVAl2UdaPwQhc
W0sxriMSrFEXWIog2uf/fc23j2/BAcK19faHXQgYskiSh0bJ0evhui5gTJ8CgRmm6FNAICT7FDAM
P+A3e6Xgit8Bn7DRFL11LpICZqz8bGEJqSTYZfFLGCXWTmVIpsUqpayhSjs3XO8xU9Tbl5iMEV4W
+urpToIYqSwhkJDHMXHTFf7Vq/qlpckqZP8Fr/ZPZmIOzdkvORwFaTDZHV82rz9cOnMKF03fG0XJ
r/zx9VjEQd/X5sduD4G3FTSMaBIx2OXjyIp0SxriqW4QGS123KLyMP97/WjvWddofP14Ige8Htgr
jZIQxdwO9MDMzcCFzSIqWWGZRymNQ3sOonlmIi9PrFLYgCyUdOZYiyx/3u3fAp0//tzuNrsfb6eO
w5pgOvxoixK+m9Jf7VebTb4JjNyds4ak4FI3C5r5KnaEzerNKlguzc3u8a/gqeyINR3xFAYzy6LK
4A0Vi4csdOvbGcZUqTYeU3GI8P2g08qSun2KMxybgP65TsVyKTR3Y8koBGKjHbUYtjQjkeWdWsQi
2v9607kf1EGaUC0rcotHzekEP/AL/BP0C4vYFxnHzZMBajtvl9rDazS+yVeHHKoE3d89vhqLXmz/
X9ZP+e/HX0ezyoKf+ebly3r7fReAXwCFgyezHiqenVV1pqBPrbMyCQ1fi8AANQ6LdXpSEjLw0jQ1
pxHuUeGGqp0AEBJp7RLwRDEXYvkel8Ieg2xGrhH0kXKs41aWiMYE2BrzaYTy+HP9AoTzTH759vrj
+/qXva5MLadAsCkEzMLBTcclhRLJSDIxPmrYLv2K01B+Q7horBm4ua7aeRSNOJJhq/gc4WuzIqHp
oNdtW01/djudjnP+Q4bqu34NLY6+XIO/ls5QqnllzywhnsTLuhtdawSVJ8ONxhHBg95i0TpwFNPu
7aLfzsPCu5v36tGULkQrS6EK7bVoSaOYtPPg5bCHB/ftXcbq9rbXeZel384CwVv/nR4blsGglUXh
bs2ZqTEIEJ1r/hI1vLvp3rZWLkLc68AkZzwO/zfGhMzbuzubT1U7B6UMjck7PCDebvskqRjfd8g7
0tOS9e7bp2lGEajEwqOhxnBB2PuO3a+uoNPao7ORf83W1+t1m2lY2MJ6l55Kc680oHUuBF9WEHot
fipXHl9/eFof/voUHFcv+acAh58lt2P1i3wr+xKeyJLqPlI6w1wp3SIrJV1jVjID7zPk0lHy0u74
Mp7dc27LBNzI/Pcfv8NAgv97/Sv/tvv18TLc59fNcf0CfnecJoeq0E7bMgA18cHvxkXWlRCkQGI+
HtNk7J4gvV9tD0Wj6Hjcr7+9HvN6i8oE21rLZs0RLgF31ZvdP5/LW7qn5vHUWYj9eQY6vAAXjYae
qAgaAq57n6oXDAj7NsQSRri9AUTxXXsDJYPX4lyY7ttqCYXOaI+7rm+KuYUg0/SzIWivm1ego1TB
HHs2+7Jdtuh377stXSetLRgULDb3c0SpTsFlCTlDNPGzjUM98aNUqBYwoajrubcphbRkt308hEnq
tTUh/eBDIUYI3MW7PBF+l6XbG3Z8M/0QI9iWFo2JNvRumwYZht57DP02MRUMvV4rw6DffY+hrYYQ
9+9vf7XjHe3HEyX6bdXXj+7KeN0Yzc/VDSf4UCx7E03HM3u3YGHTqWWVdcfCzNwqI7e6AGpq7rSB
3Tbw1nX4XUIDO+oFWmHxBaounHp8bkW9ISvD6gpFJUioCa8SGZWSywrpTyL55Xrh9WBOp82dS2Mf
v56wpKp2lF/GV4SQoNu/vwk+ROt9Pod/H13FDV/B1qgAzKTPewDMCpl6PGvkOQBtVL0IMKSq12Eo
pzyIosUkP/6z2/+13v5otpgQ7WBrZJ8IhKfEPm0svjPGiru56x0M0aBbxcw55jRNqJUfAbzZlFjn
nDSxW6Ci1A+MVJWKwlkRfGaSp5W7gHMJEZsIeVTJZQCsYM+iOUNy6gASpB3Ui4o6MM1dDcyIHHFF
Kv6nyEQiHAIxIqCCiqpQqBhLUpNqScxGkqPQSMTlyMLwiy5UOiUoUyybdV3EXuVuQgpn9sXSpBfx
Ka1I0/QITWoEokSNQoXJTDrrFxX/CWbr/fF1tQlUvjeHoZXbosrqEdlMOQc5G1RFOxuArtMZwu5T
F9OPAfS1BSSeXbFEyzG4GUzjOk0SErsnN6JxqaH2VJZEj603MoJ1+H29OTrEcxVOEhnTkGiJcFWZ
AYi0qJOoxHWSdrAhZo6i69RaRtipRuFYYkBnSOMJbDCMajcEfgpKxsQNMoTdgJhqvRTeUnLqQYrl
y6WnL/UVfAEkwSTxFCI4cQOhwsKNoEltcdiiIsm4Zl6u/bNT6CoAFkx5+j4hsaiZxQsGgZT2CNGr
TiXM50mz0ot+VzULyTEsfkn+qFxQlWDdzJYkWBcE4nBPTQwp0EGJQuJtqn4bVoFh0TEkPKBCrG6s
T30qEi/chvbEoRImshFSFLvG5Fh0huxYd4asPXT3mgTiOPaJw6HWJ8ShuyfEpbwX8TeX1wnCMVKK
RksPDOGCB0n9kFu3YXtyGxwA3GoIQLuYEu7Ud4nmnlUchtJvhCRBMbtudX8P/idDPnAa2IHPwg7q
JvbZiRkz6kakrwgXWnmgSKKxB5rEvh5cDK+nucKc+HoP+uaGzI47Ieba08OAJsbQurGTpXWDJKWD
mwZ20qw62VLvZm2FxnlKOIdWUbhFJFn1q8hdux4ealHLsflgZ4Z/rHgJhtuOucx3Fo4g+FJjTxR6
YuCjP3Ci/TwTUDGTRkbeYVET1HUeFZwZWHhb8UK1O6NzJGk4dt32zWKUZMNOr1u5UQrB0BF39+MY
9zzenPvwwSTKTd3ZlD33aX6MxMjj7YfmRl5XEsHgf09X5zC0MshxJ7xBfRHEAgWLl2Myz6KYz4EC
jHHD4XzYKXOK8GW3D76v1vvgv6/5a17m01iVFPmL9ZBEGa8BwvQ/aBRBeODtwZkPFoBJDuJRiJYe
8ZxZsUirMVEBjB6axIkeOYiRwq7eQqDAW1qWtgdyJqrI0aomD7GDOoqaxLGz1lCddtVGH+F/Z7rB
GacJ1GjvjwZ44DUCUSBqpO0zkKTYr1WDABsuTUKyaAKFYt146E1yNG/S0n4lyDyRMjBYkVdfDBNN
Qo8Mig6omXB0C6iDJhnZfmERuGKdCR5TTGonH8ExPxwbug+hx5gklSqqLztOhEwumjTwMGo9Lcin
1RhXg8MJYuDkeg6jqfRlsmi3pEIygyFa8x2mjC0riSc8CWv3J1ez9JCimP5JXHdAurijKbNHJN7m
RytvxzpPqJvgMgHr+DPfmyIfup0AjE6302Hf1sePVZkTkyRZOQ5i1fz/CRJiyYgnjVKlEGH6FlF5
tZX1Iay/Vj8DV8VeAuDnTTi/DFO/btYvYCCf15u3YHvSFv/RoWlGpzF1HxtMRNd5gVxoRz3dEIie
E2PEwmG32zWycuMhEppgE/PJCMIjt/LcuN9IlCkOvqrDsXQdzhAiJO92KpkjZ5r3koX4rj4imN3E
vSVDXKQIox4L0pvWU/8u4LDbv8eukzgDaG4dvp4Iptv2cM5kWAIk03OqfJvzmXHY7d17GcylG5gN
2HiUxwVQVN175EMExd5roxRixgS751z7XkDNKMqkeWblRWcEgmKql63LGvp0XtJWZjJJPPd4Ydyb
ejXDPbxEDftDT0IIGFHzVsyJLUkMrlDkuceTw+7APVdqej+MPaU0HfOk/45AHBKhi/HI3VjPkdWl
d3/l20Cas3mHrdXNJE9zL7HJD4fATPaH7W77+efqeb96Wu8+1i1VY88pK1htg/U5ab/S2tyjPlEY
usU+oUJ4EpCF50LSZzsLn9dzQwl7gnO7gjImh4AXYVkZnqswAbv97fB2OObPlVkxSEP4IMmXn7vt
myvbGPaJpPnakm5fXo/+a55EpJdrl/SQ7zfmIq8ibZszYxxiQNjP7eN1m54JhdKFF1VYEpJki6/d
Tu+mnWf59W4wtI/ADdMffFm70KkxaOW+8ClRMiu7XitEZs4D8EJw9At35VaMESP11OLLGxYweRcG
K4UEQmNe+8zosHPTqxPh56noVaUKAOthD991PZa2YIH9RqieZzCNtPCKGKZkWSQ9Wq+QTxSIPKej
StR1QcC+T0fupIcLTzx9l2Wh32VJyFw7HzRZ+mO/DS6e1Kle9d2vIRpBedy1kmGmFosFQi1qBnoI
YQ2etmkiT/Gk1OUWLpO033xW8nO1Xz2a07pGFvrMUqiZzs7W5PpEa27RKqqBYnNKUqb4S0cqWb5f
r+w0omrRYe+246jRkM8NepXyzFe8z3KsF4slkVmKpFZfb9xVkIUGn5k0u5/AtmI4gFKMo/YioFoV
5tISmbkLvh9mQi+tCOX8FsVDhCrSRH/t3Q6u/XyguNPL6qnZp0NYRu3jMEbBOUjCWtBV0AUC7yQr
3lw4D/yZyc0w4VT5Ci1CuHJeC7Ci9rkeEObmWDHklzS5+er4+PNp9yMw712sqbb4ahTQnDla8utO
canCZ1HMQ75rhc+2+/WQQgiQzUPtiRVmCAaGJ36OmLLubf+2lQGMZNfLoPBtr+NFSSp5awfo6K7j
Lz5HEZF19PIudbHIwAWonoSaLN6Wvv5qgwcdqNEHYpH6pTQf9ge9u0nUxjC8u/Pjxrn9s46eX0V9
/rY65E9NVbMffAl8VhB3+6F2vZtK1ejdyoHHXfnVSkpYf3bYncwqz1rKN9XXyEB7Dl5l/37gjluR
EDGFyN49qzxZiubYojLxFhz24Ptm9/LyVmTinp230jZXYpmx2zcNpeevEczRzG2nJZo7HmlZr80r
Rx7m9TlIyLye8LA38nHA3o2Lt+2eZ5m0h11JSPa9ZQ9neAJ7V+HCXQqhzY/dfn38+XyolCte/I8q
V/8nosCRXX4CylM88Pa8/CuLUWNx3NbgjA/67fiiBWfh3e2gDTbnKy6DAii4kN3qKOmw26lRFLJt
jiElxcFKz9vo6e1cFtPxRHuaNg8MbipbmCFKrtDMl8dvOEr4ps3eITzyFzdPAO5v2/CB5wHGCb4f
LLzwjKI2DEbnhzkPOW9G4BcVU/n2sNsfwMFbvzi1HTyURNlH5eW3Mk9xIGTqVjaOCnTrcb8snr7z
/uvMoUbmvMxRf6i67hdMZ4bI3MlYV5Nn+ji+7Q4VawJUD++a1Jjd3braB/pdS+sAD93F3KnBV7jv
6sPw1kW9d0qGoUV30L1vaQUUZjAcoGaVsLneDbuhE4jvhrfFFXijwfOe3dAwbs54CnPmVq1zBcUZ
aPUvLpwQsIrD27ubVi0qeO67rTywLQxvPVuiUfDyPbDxwN9hMab6HZaR568TWO1Mqqc35ePo1Waz
Ovz7EHQ//7OGVfnttXqo1G3mPa8Pj67TLjpisHCYO0/6OX9ar1ylZjQkvJ6YWvZs/WN9hOhltn7K
d8Fov1s9Pa6Ki6Dzw2i7nrD6iqh84r1fvfxcPx6aKhCNKo+2RxmmUnoECKhgPR+E/7+xK9ltHAei
v9Lo2xwG3V5jH+ZAbTZjaolIZemL4OkYmWDScZA4wPTfTxVlW6TIknyIA1UV9+JarMeHIC7H1Iko
CDDJBWeE0R74PJWKZN6u2GhOMmPb4d+qURmL5uaVGWK9YlRkeFeT4qVMlfk9GZJBelnXUaXLbzt3
G6RZ0XjiorAysDrVw2i8sGIDkjk+NJQ6JCsVuSuyODAjUqwszlNG+b0Af/NAzIfAm0QJmWQzVY4o
tiqhRWkFuuWlqph7hSDcw/z6Aivl54839OxvVsxuXwAd8x2TpBHzHWaYRkv3xCWBfQO0XYK7vvZw
1zBfZcoL0Qf0evHfwoiooWiUxiNO3tP+iPbouZcs8pV7VC73n6+PppQ+jPTtodxKAaJZGfBJeYHA
aLiDIfR1t4clM8blXNJvAuMxhQ15g/QAdl53PPL6WuhwDxlLeVinPMvLs68iJrPefxywjQ/v+5cX
aFcPJBNGEK9DXq/DiIg/P7KNEyCgVi31nN7xcCOE2eLDdwisSyOqWOW5wiuy/nvfKMXClOQVpT7J
IXIrVV6yVdytxCPZbSGvVAmbu1jFxPhgxccUS1gwKJeUcUxtbk05LqMxMVFYyRbhcFzrYgFx7Qbl
ZBSV35cXic1mg2LXVaq9erydaP35a/vaIkq18CVrHv1hd4c172gcEE7WF8M+FdVJQqgCMDvmC61a
vFDxhizGHetrpk2gehpb4y/BTBiTEqk+5SbZ8YoJdk+y7wsW0V1G8bqM01zF3prnv7ZPhA1SZywK
Fz16p6Hg+qptXcBvFxzjnHj/+k4PYixAwW5gvbCbiufXz//O/nMos9s97h41OIk3+i5EDQqdbgpt
H7dvh707MIVMhXS7szvqRoVueGg4CvoL+aUSi9GMrl748924wWzrIj/auERIP9ofYHQHzsGatO1u
6Rhv2lax5iVivI5TPh/TCpvy8ZzkKr4StL5WcSnvmKA1uuT5rEcnRbzKFfY4WiKMekLTvPBBI73R
zb3GK60KqvY2pwsfS3+LrraPT7uDzyCNwVYMo3ZPOhHyqjF6W8jSatzgE9iE+h594F1yAxTNQuGy
ZBxWJVcPFmfSjXzij3xCRz7xR35tm0fhk17RyzoNNGSpCaHIofYT2UEIPJP1yaknrrOARnbgWZJ7
4+wW0WR5immyjaK2pdMsf9HM6NrryU6Ads3NM5AnmGWeUkndVLmyoDVuEAPt1ndO1XAMK7sO24CC
t0fplcqptBre1EDOaKAxvkW3kdZkR5G5zJfz+fdOc17nghO3q35ACKISqijpZKs5K8jlt4Spb7BL
8mYhQQcfK/lUQhh/CW9d6Uw51dEYdz52n497jVnnpNnii5iEjW1vlQ/SFIEljaP3DS1FGysBKod8
qoMBt1A+tW8ZbgdWaWHmal3BqCUCD6kumOkzCLu/Vi3sGciuIsPCSfcGltC8dS+rEBXJDmI6aECz
ekJdQz7HGuwfb4BzPAspFAmnHupK8l/l6xka1gXNu8nupzQXXxSgeJVfrU/LKT0xya5iZycVNb7N
Rwb099T+bhwBzSs/QI3sr24kUTeWCJ3QzHcJwk3U+bSCxPdotDGzKqusNB9XaL7rlXlxHwjQI5BW
b8pgZqJJB1hu8ygaKJnAzpewSvgMQyE3k8cv7ezZpZ36Zqsl/DR9+O/bhQXVpGEeMbpH+Uex7fvh
WTstqd9vOwteoFQcVfns3W/D5uZl1sp4U8xlMiDBUr5iQzKKlXxABr2WvBLWgH+WsACWQLMQ/U2w
IBY9E7Osgv48yFxARmWDudsrifdsNIJof7oiSgcikquhigHFLCHzA9FUQy0ZJ0RCzYixPcAO44vY
vj59bp92Lph0Zrm4tH3mr6/PH/vFYrb8c/TV0G8QQHBynF7q6cT/AIAldHWR0NVsWGhB7OU6QuNL
hC5K7oKML+aX5Gk+ukTokowT5vuO0PQSoUuqgECn6wgth4WWkwtiWl7SwMvJBfW0nF6Qp8UVXU+w
0EXdrxfD0YzGl2QbpGglYDIkXqcw8zIalBgPSkwGJYbrZDYoMR+UuBqUWA7Xx3BhRsOlGdHF2eR8
UZf97IpkVypZuDP6+x4W3DaykPGuRZ5w4UPo26BvxMuXf7Y//7X87Rr78QZ9v8wDAFaKh+bEfmNv
WFAaljnhJr+FrbPI73rQsLVcXUnqjsxRSjCf7642x+EKt7zx5KDgGS4Ke6LFPsOEyMMeGc/zFR0J
PGroy/sxH83jB76TArSawWpPmz7Mckw3unYk8QRJwjN8vaRw4Kj0Sx4FzNby7Espdz+bd8wc85S7
/TtR0EUDX4TxcEJWsACUSHEbg/4sUOYN3DtxP+IoJWPQw+retV2+/3477J8a+72b5QbF21hD62/t
ue4Qs0oYaAhHYhpNPbSZExj95H3E8WzuhAfybDR2yJHp63mkBdrdSa4dYahuLx2dIBD5pktnsaxn
CzcviEU181ItsLdTqjEjtqpNImU49W1tTuVLhIVec6pOHq5ZLPC/m5EynIxdMp6qnnyBxPPf79v3
31/e95+H59ed1fhhHYZcWbURTowjLcGDbgo/gIb91M6qpjoF0G+GpZ3Hjdaq8/4Rh91EGdsPouin
fqAzoxuz9W4AquX/K6apysxwAAA=
------=_Part_35_27542634.1091843732469--
